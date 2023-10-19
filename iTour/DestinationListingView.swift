import SwiftUI
import SwiftData

struct DestinationListingView: View {
    @Query(sort: [
        SortDescriptor(\Destination.priority, order: .reverse),
        SortDescriptor(\Destination.name)
    ]) private var destinations: [Destination]
    @Environment(\.modelContext) var modelContext

    init(sort: SortDescriptor<Destination>, searchText: String = "") {
        _destinations = Query(
            filter: #Predicate { searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) },
            sort: [sort]
        )
    }
    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)
                        Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    DestinationListingView(sort: SortDescriptor(\Destination.name))
}
