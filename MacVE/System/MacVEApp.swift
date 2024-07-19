//Created by Lugalu on 11/06/24.

import SwiftUI
import CoreData
@main
struct MacVEApp: App {
    let persistance = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup{
            ProjectSelectorView<ProjectSelectorModel>()
                .environment(ProjectSelectorModel())
        }
        .defaultSize(width: 700, height: 400)
        .windowResizability(.contentSize)
        
        WindowGroup("Project", for: Project.ID.self) { $id in
            PlaybackView<PlaybackModel>()
                .environmentObject(PlaybackModel())
        }
        .defaultSize(width: 1200, height: 700)
        .windowResizability(.contentSize)
    }
}



