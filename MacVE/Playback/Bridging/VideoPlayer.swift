//Created by Lugalu on 11/06/24.

import AppKit
import SwiftUI
import AVKit

struct VideoPlayer: NSViewRepresentable {
    @Binding var player: AVPlayer
    
    func makeNSView(context: Context) -> AVPlayerView  {
        let playerView = AVPlayerView()
        playerView.player = player
        playerView.controlsStyle = .none
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        nsView.player = player
        nsView.player?.play()
    }
    
}
