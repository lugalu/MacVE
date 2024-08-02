//Created by Lugalu on 11/06/24.

import SwiftUI
import CoreData
@main
struct MacVEApp: App {
    let persistance = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup("Project Selection"){
            ProjectSelectorView<ProjectSelectorModel>()
                .environment(ProjectSelectorModel(database: persistance))
        }
        .defaultSize(width: 700, height: 400)
        .windowResizability(.contentSize)
        
        WindowGroup("Project", id: "ProjectView", for: Project.ID.self) { $id in
            if let id = $id.wrappedValue?.unsafelyUnwrapped,
               let viewModel = EditorViewModel(persistance: persistance, projectID: id) {
               EditorView(viewModel: viewModel)
                    .onAppear{
                        print(id, viewModel)
                    }
                    .frame(minWidth: 1200, minHeight: 700)
            }else{
                EmptyView()
            }
        }
        .commandsRemoved()
        .defaultSize(width: 1200, height: 700)
        .windowResizability(.contentMinSize)
    }
}



