//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

@MainActor
protocol PlaybackModelProtocol: ObservableObject {
    var player: AVPlayer { get }
    var isPlaying: Bool {get set}
    var volumeLevel: Float {get set}
    var command: PlaybackCommands? {get set}
    var resolution: PlaybackResolution { get set }
    
    func playback(command: PlaybackCommands)
    func loadVideo()
    
}

class PlaybackModel: ObservableObject, Observable, PlaybackModelProtocol {
    @Published var player: AVPlayer = AVPlayer()
    @Published var isPlaying: Bool = false
    @Published var command: PlaybackCommands? = nil
    @Published var resolution: PlaybackResolution = ResolutionSyncer.currentResolution {
        didSet{
            ResolutionSyncer.currentResolution = resolution
        }
    }
    
    @Published var volumeLevel: Float = 1.0 {
        didSet{
            player.volume = volumeLevel
        }
    }
    
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(onPlayerEnd), name: AVPlayerItem.didPlayToEndTimeNotification, object: player.currentItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func onPlayerEnd(){
        isPlaying = false
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
                let trackDuration = try await assetURL.load(.duration)
                var instructions: [AVVideoCompositionLayerInstruction] = []
                let composition = AVMutableComposition()
                
                for track in tracks {
                    let compositionTrack = composition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: kCMPersistentTrackID_Invalid)
                    try compositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: trackDuration), of: track, at: .zero)

                    if track.mediaType == .video {
                        guard let id = compositionTrack else { continue }
                        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: id)
                        
                        instructions.append(instruction)
                    }
                    
                    
                }
                
                let videoComposition = try await AVMutableVideoComposition.videoComposition(withPropertiesOf: composition)
                videoComposition.customVideoCompositorClass = ResolutionChangerCompositor.self
                let instruction = AVMutableVideoCompositionInstruction()
                instruction.layerInstructions = instructions
               // videoComposition.instructions = [instruction]
                let playerItem = AVPlayerItem(asset: composition)
                playerItem.videoComposition = videoComposition

                player.replaceCurrentItem(with: playerItem)
                
            } catch {
                print("Error")
            }
        }
    }

    
}
