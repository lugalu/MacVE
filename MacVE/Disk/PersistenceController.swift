//Created by Lugalu on 19/07/24.

import CoreData


enum DatabaseErrors: LocalizedError{
    case itemDoesntExist
    
    
    var errorDescription: String? {
        return switch self {
        case .itemDoesntExist:
            "this ID doesn't exist"
        }
    }
}

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        for i in 0..<10 {
            let proj = Project(context: controller.context)
            proj.title = "Preview Title \(i)"
            
            let randomTime = TimeInterval(Int32.random(in: 0...Int32.max))
            proj.lastAccess = Date(timeIntervalSince1970: randomTime)
        }

        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
    
    func fetch() throws -> [Project]  {
        let request = NSFetchRequest<Project>(entityName: "Project")
        let result = try context.fetch(request)
        return result
    }
    
    func fetch(_ id: UUID) throws -> Project? {
        let request = NSFetchRequest<Project>(entityName: "Project")
        request.predicate = NSPredicate(format: "%K == %@","id", id as CVarArg)
        return try context.fetch(request).first
    }
    
    func delete(_ id: UUID) throws {
        guard let proj = try fetch(id) else {
            throw DatabaseErrors.itemDoesntExist
        }
        context.delete(proj)
        try save()
    }
}
