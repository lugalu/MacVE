//Created by Lugalu on 11/06/24.

import SwiftUI

@main
struct MacVEApp: App {
    var body: some Scene {
        WindowGroup {
            ProjectSelectorView()
                .frame(width: 700,height: 370, alignment: .leading)
                .fixedSize()

            
//            PlaybackView<PlaybackModel>()
//                .environmentObject(PlaybackModel())
//                .frame(minWidth: 1200, minHeight: 700)
        }
        .windowResizability(.contentSize)
    }
}
