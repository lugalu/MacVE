//Created by Lugalu on 16/06/24.

import AVKit
import SwiftUI

enum PlayerErrors: LocalizedError {
    case failedToRetrieveTrack
    
    public var errorDescription: String? {
        return switch self {
        case .failedToRetrieveTrack:
            "Couldn't retrieve video track"
        }
    }
}

class PlayerOperations {
    static let shared = PlayerOperations()
    @AppStorage("SkipAmount") public static var secondsToSkip: Double = 5
    
    private init(){}
    
    func playPause(for player: AVPlayer, shouldPlay isPlaying: Bool){
        isPlaying ? player.play() : player.pause()
    }
    
    func skip(fowards: Bool, forPlayer: AVPlayer) {
        guard let videoDuration = forPlayer.currentItem?.duration else { return }
        let seconds = PlayerOperations.secondsToSkip

        let playerTime = CMTimeGetSeconds(forPlayer.currentTime())
        
        var newTime = playerTime
        newTime += fowards ? seconds : -seconds
        newTime = clamp(minValue: 0, value: newTime, maxValue: CMTimeGetSeconds(videoDuration))
        
        let convertedtime = Int64(newTime * 1000 as Float64)
        let seekTime = CMTimeMake(value: convertedtime, timescale: 1000)
        
        forPlayer.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func jumpTo(end:Bool, player: AVPlayer) {
        var time: CMTime = CMTimeMake(value: 0, timescale: 1000)

        if end, let duration = player.currentItem?.duration {
            time = duration
        }
        
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func getNaturalResolution(for asset: AVAsset) async throws -> CGSize {
        guard let track = try await asset.loadTracks(withMediaType: .video).first else {
            throw PlayerErrors.failedToRetrieveTrack
        }
        
        let originalResolution = try await track.load(.naturalSize)
        return originalResolution
    }
    
    
    func changePlayerResolution(for player: AVPlayer, with resolution: PlaybackResolution) {
        guard let item = player.currentItem else { return }
        let asset = item.asset
        Task(priority: .userInitiated) {
            do {
                guard let track = try await asset.loadTracks(withMediaType: .video).first else {
                    return
                }
                
                let originalResolution = try await track.load(.naturalSize)
                let width = originalResolution.width
                let height = originalResolution.height
                let scale = CGFloat(resolution.getValue())
                
                let newResolution = CGSize(width: width * scale, height: height * scale)
                
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
    
    
    func getScaledResolution(for original: CGSize, with resolutionScale: PlaybackResolution) -> CGSize{
        let width = original.width
        let height = original.height
        let scale = CGFloat(resolutionScale.getValue())
        return CGSize(width: width * scale, height: height * scale)
    }
}
