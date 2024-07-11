//Created by Lugalu on 11/06/24.

import SwiftUI

@main
struct MacVEApp: App {
    var body: some Scene {
        Window("Project Select", id: "SelectorView") {
            ProjectSelectorView<ProjectSelectorModel>()
                .environment(ProjectSelectorModel())
        }
        .windowResizability(.contentSize)

        WindowGroup("Project", id: "PlaybackView" ){
            PlaybackView<PlaybackModel>()
                .environmentObject(PlaybackModel())
        }
        .defaultSize(width: 1200, height: 700)
        .windowResizability(.contentSize)

    }
}
