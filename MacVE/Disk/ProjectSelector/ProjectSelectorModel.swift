//Created by Lugalu on 09/07/24.

import SwiftUI

@MainActor
protocol ProjectSelectorModelProtocol: ObservableObject {
    var isCreatingProject: Bool { get set }
    
    func createNewProject(withTitle: String)
    
}


class ProjectSelectorModel: ObservableObject, Observable, ProjectSelectorModelProtocol {
    
    
    @Published var isCreatingProject: Bool = true
    
    func createNewProject(withTitle title: String) {
        var database = PersistenceController.shared
        var context = database.container.viewContext
        var test = Project(context: context)
        test.title = title
        test.lastAccess = Date()
        test.id = UUID()
        
    }
}
