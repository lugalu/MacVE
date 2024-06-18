//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

@MainActor
protocol PlaybackModelProtocol: ObservableObject {
    var player: AVPlayer { get }
    var isPlaying: Bool {get set}
    var volumeLevel: Float {get set}
    var command: PlaybackCommands? {get set}
    
    func playback(command: PlaybackCommands)
    func loadVideo()
    
}

class PlaybackModel: ObservableObject, Observable, PlaybackModelProtocol {
    @Published var player: AVPlayer = AVPlayer()
    @Published var isPlaying: Bool = false
    @Published var command: PlaybackCommands? = nil
    
    @Published var volumeLevel: Float = 1.0 {
        didSet{
            player.volume = volumeLevel
        }
    }

    
    func playback(command: PlaybackCommands) {
        let operations = PlayerOperations.shared
        
        switch command {
        case .backward:
            operations.skip(fowards: false, forPlayer: player)
            
        case .backwardEnd:
            operations.jumpTo(end: false, player: player)
            
        case .playPause:
            isPlaying.toggle()
            operations.playPause(for: player, shouldPlay: isPlaying)
            
        case .foward:
            operations.skip(fowards: true, forPlayer: player)
            
        case .fowardEnd:
            operations.jumpTo(end: true, player: player)
        }
    }
    
    //MARK: Temporary and reference for creating compositions!
    func loadVideo(){
        let url = URL(filePath: "video2.mp4", directoryHint: .checkFileSystem, relativeTo: .downloadsDirectory)
        let assetURL = AVURLAsset(url: url)
        Task{
            do {
                let tracks = try await assetURL.load(.tracks)
                
                let composition = AVMutableComposition()
                
                for track in tracks {
                    let compositionTrack = composition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: kCMPersistentTrackID_Invalid)
                    let trackDuration = try await assetURL.load(.duration)
                    try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: trackDuration), of: track, at: .zero)
                }
                
                let playerItem = AVPlayerItem(asset: composition)
                player.replaceCurrentItem(with: playerItem)
            } catch {
                print("Error")
            }
        }
    }

    
}
