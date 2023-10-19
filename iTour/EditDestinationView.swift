import SwiftUI
import SwiftData

struct EditDestinationView: View {
    @Bindable var destination: Destination
    @State private var text = ""
    var body: some View {
        Form {
            TextField("Name", text: $destination.name)
            TextField("Details", text: $destination.details, axis: .vertical)
            DatePicker("Date", selection: $destination.date)

            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }

            Section("Sites") {
                List(destination.sights) { sight in
                    Text(sight.name)
                }
                HStack {
                    TextField("Sight", text: $text)
                        .textFieldStyle(.roundedBorder)
                    .onSubmit(addSight)
                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit destination")
        .navigationBarTitleDisplayMode(.inline)
    }

    func addSight() {
        guard !text.isEmpty else { return }
        destination.sights.append(Sight(name: text))
        text = ""
    }
}

#Preview {
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: configuration)
        let example = Destination(name: "Name", details: "details")
        return  NavigationStack {
            EditDestinationView(destination: example)
                .modelContainer(container)
        }
    } catch {
        fatalError()
    }
}
