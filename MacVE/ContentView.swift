//Created by Lugalu on 11/06/24.

import SwiftUI

struct ContentView: View {
    var body: some View {
        PlaybackView<PlaybackModel>()
            .environmentObject(PlaybackModel())
    }
}

#Preview {
    ContentView()
}
