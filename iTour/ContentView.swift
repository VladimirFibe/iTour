import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: [
        SortDescriptor(\Destination.priority, order: .reverse),
        SortDescriptor(\Destination.name)
    ]) private var destinations: [Destination]
    @Environment(\.modelContext) var modelContext
    @State private var path = [Destination]()
    var body: some View {
        NavigationStack(path: $path) {
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
            .navigationTitle("iTour")
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
            .toolbar {
                Button("Add Destination", systemImage: "plus", action: addDestination)
            }
        }
    }

    func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }

    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    ContentView()
}
