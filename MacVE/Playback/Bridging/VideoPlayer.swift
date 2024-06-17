//Created by Lugalu on 11/06/24.

import AppKit
import SwiftUI
import AVKit

struct VideoPlayer<T: PlaybackModelProtocol>: NSViewRepresentable {
    @EnvironmentObject var viewModel: T
    
    func makeNSView(context: Context) -> AVPlayerView  {
        let playerView = AVPlayerView()
        playerView.player = viewModel.player
        playerView.controlsStyle = .none
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) { }
}
