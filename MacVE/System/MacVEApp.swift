//Created by Lugalu on 11/06/24.

import SwiftUI

@main
struct MacVEApp: App {
    var body: some Scene {
        WindowGroup {
            PlaybackView<PlaybackModel>()
                .environmentObject(PlaybackModel())
                .frame(minWidth: 1200, minHeight: 700)
        }
    }
}
