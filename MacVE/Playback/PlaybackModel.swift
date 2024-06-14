//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

@MainActor
protocol PlaybackModelProtocol: ObservableObject {
    var player: AVPlayer { get }
    var isPlaying: Bool {get set}
    var volumeLevel: Float {get set}
    var command: PlaybackCommands? {get set}

    
    var resolution: PlaybackResolution {get set}
    
    func playback(command: PlaybackCommands)
    
    
}



class PlaybackModel: ObservableObject, Observable, PlaybackModelProtocol {
    @Published var player: AVPlayer = AVPlayer()
    
    @Published var isPlaying: Bool = false
    @Published var volumeLevel: Float = 1.0 {
        didSet{
            player.volume = volumeLevel
        }
    }
    @Published var command: PlaybackCommands? = nil
    
    @Published var resolution: PlaybackResolution = .fullResolution
    
    func playback(command: PlaybackCommands) {
        if command == .playPause, player.currentItem != nil {
            isPlaying.toggle()
        }
        self.command = command
    }
}
