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
        
        WindowGroup("Project", for: Project.ID.self) { $id in
            if let id = $id.wrappedValue?.unsafelyUnwrapped {
                PlaybackView<PlaybackModel>()
                    .environmentObject(PlaybackModel(database: persistance, id: id))
            }
        }
        .commandsRemoved()
        .defaultSize(width: 1200, height: 700)
        .windowResizability(.contentSize)
    }
}



