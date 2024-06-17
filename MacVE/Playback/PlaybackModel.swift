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
    @AppStorage("SkipAmount") var secondsToSkip: Double = 5
    
    @Published var isPlaying: Bool = false
    @Published var volumeLevel: Float = 1.0 {
        didSet{
            player.volume = volumeLevel
        }
    }
    @Published var command: PlaybackCommands? = nil
    @Published var resolution: PlaybackResolution = .fullResolution{
        didSet{
            self.changePlayerResolution()
        }
    }
    
    func playback(command: PlaybackCommands) {
        let operations = PlayerOperations.shared
        let seconds = PlayerOperations.secondsToSkip
        
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
    
    private func changePlayerResolution() {
        guard let item = player.currentItem, let composition = item.customVideoCompositor else {
            return
        }
        let operations = PlayerOperations.shared
        let asset = item.asset

        Task(priority: .userInitiated) {
            do {
                let originalResolution = try await operations.getNaturalResolution(for: asset)
                let test = try await asset.loadTracks(withMediaType: .video).first
                
                let newResolution = operations.getScaledResolution(for: originalResolution, with: resolution)
                
                let pixelBufferAttributes: [String: Any] = [
                            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
                        ]
                let output = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBufferAttributes)
                
                item.add(output)

            }catch {
                print("SHIT")
                return
            }
        }
    }
    

    
 
}
