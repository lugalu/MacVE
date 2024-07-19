//Created by Lugalu on 09/07/24.

import SwiftUI
import AVKit

@MainActor
protocol ProjectSelectorModelProtocol: ObservableObject {
    var isCreatingProject: Bool { get set }
    var title: String {get set}
    var error: Bool {get set}
    var projects: [Project] {get set}
    
    func createNewProject(withTitle: String) -> Project?
    func fetchProjects()
    func delete(withID: UUID)
}



class ProjectSelectorModel: ObservableObject, Observable, ProjectSelectorModelProtocol {
    @Published var isCreatingProject: Bool = false
    @Published var title: String = ""
    @Published var error: Bool = false
    @Published var projects: [Project] = []
    
    func createNewProject(withTitle title: String) -> Project? {
        let database = PersistenceController.shared
        let newProject = Project(context: database.context)
        newProject.title = title
        newProject.lastAccess = Date()
        newProject.id = UUID()
        newProject.composition = AVMutableComposition()
        
        do{
            try database.save()
        }catch {
            return nil
        }
        projects.append(newProject)
        projects = sort()
        return newProject
    }
    
    func fetchProjects() {
        let database = PersistenceController.shared
        do {
            projects = try database.fetch()
            projects = sort()
        }catch{
            //TODO: Throw!
            fatalError("hm \(error.localizedDescription)")
        }
    }
    
    func delete(withID id: UUID){
        let database = PersistenceController.shared
        do{
            try database.delete(id)
            fetchProjects()
        }catch{
            //TODO: Show error!
            fatalError("ops: \(error.localizedDescription)")
        }
        
    }
    
    func sort() -> [Project] {
        return projects.sorted(by: { $0.lastAccess ?? Date() > $1.lastAccess ?? Date() })
    }
}
