//Created by Lugalu on 09/07/24.

import SwiftUI
import AVKit

@MainActor
protocol ProjectSelectorModelProtocol: ObservableObject {
    var isCreatingProject: Bool { get set }
    var title: String {get set}
    var error: Bool {get set}
    
    func createNewProject(withTitle: String) -> Project?
    
}


class ProjectSelectorModel: ObservableObject, Observable, ProjectSelectorModelProtocol {
    @Published var isCreatingProject: Bool = false
    @Published var title: String = ""
    @Published var error: Bool = false
    @Published var projects: [Project] = []
    
    func createNewProject(withTitle title: String) -> Project? {
        let database = PersistenceController.shared
        let test = Project(context: database.context)
        test.title = title
        test.lastAccess = Date()
        test.id = UUID()
        test.composition = AVMutableComposition()
        
        do{
            try database.save()
        }catch {
            return nil
        }
        return test
    }
    
    func fetchProjects() {
        let database = PersistenceController.shared
        do {
            projects = try database.fetch()
        }catch{
            //TODO: Throw!
        }
    }
}
