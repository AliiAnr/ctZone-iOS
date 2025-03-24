import SwiftUI
import CoreData

struct CoreDataDebugView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    private var locations: FetchedResults<LocationEntity>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Locations")) {
                        ForEach(locations, id: \.self) { location in
                            NavigationLink(destination: LocationDetailDebugView(location: location)) {
                                VStack(alignment: .leading) {
                                    Text(location.name ?? "Unknown")
                                        .font(.headline)
                                    Text("ID: \(location.id?.uuidString ?? "No ID")")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Core Data Debug")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Delete All Data", action: deleteAllData)
                    }
                }
            }
        }
    }
    
    // Fungsi untuk menghapus semua data dari semua entitas
    func deleteAllData() {
        guard let persistentStoreCoordinator = viewContext.persistentStoreCoordinator,
              let entities = persistentStoreCoordinator.managedObjectModel.entities as [NSEntityDescription]? else {
            return
        }
        
        let concreteEntities = entities.filter { !$0.isAbstract && $0.name != nil }
        
        concreteEntities.forEach { entity in
            if let name = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                do {
                    if let result = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult,
                       let objectIDs = result.result as? [NSManagedObjectID] {
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [viewContext])
                        print("DEBUG: Deleted objects for entity: \(name)")
                    }
                } catch {
                    print("DEBUG: Failed to delete objects for entity \(name): \(error)")
                }
            }
        }
    }
}

struct LocationDetailDebugView: View {
    var location: LocationEntity
    
    var body: some View {
        Form {
            Section(header: Text("Basic Info")) {
                Text("Name: \(location.name ?? "Unknown")")
                Text("ID: \(location.id?.uuidString ?? "No ID")")
            }
            
            Section(header: Text("Additional Info")) {
                Text("Country: \(location.country ?? "None")")
                Text("Image: \(location.image ?? "None")")
                Text("Timezone Identifier: \(location.timezoneIdentifier ?? "None")")
                Text("UTC Information: \(location.utcInformation ?? "None")")
                Text("Is City: \(location.isCity ? "Yes" : "No")")
                Text("Is Pinned: \(location.isPinned ? "Yes" : "No")")
            }
        }
        .navigationTitle(location.name ?? "Detail Location")
    }
}




#Preview {
    CoreDataDebugView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
