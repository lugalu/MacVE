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
}
