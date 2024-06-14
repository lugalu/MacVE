//Created by Lugalu on 11/06/24.

import AppKit
import SwiftUI
import AVKit

struct VideoPlayer<T: PlaybackModelProtocol>: NSViewRepresentable {
    @EnvironmentObject var viewModel: T
    @AppStorage("SkipAmount") var secondsToSkip: Double = 5
    
//    private let videoCompositor = VideoCompositor()

    
    
    func makeNSView(context: Context) -> AVPlayerView  {
        let playerView = AVPlayerView()
        playerView.player = viewModel.player
        playerView.controlsStyle = .none
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        guard let player = nsView.player, let playerItem = player.currentItem else { return }
//TODO: get original Resolution to multiply via the res, change things here for
        executeCommand(on: player)
    }    
    private func executeCommand(on player: AVPlayer){
        switch viewModel.command {
        case .backward:
            changeTime(by: -secondsToSkip, player: player)
            
        case .backwardEnd:
            jumpTo(end: false, player: player)
            
        case .playPause:
            if viewModel.isPlaying {
                player.play()
                break
            }
            player.pause()
            
        case .foward:
            changeTime(by: secondsToSkip, player: player)
            
        case .fowardEnd:
            jumpTo(end: true, player: player)
        case .none:
            return
        }
    }
    
    
    func changeTime(by duration: Double, player: AVPlayer) {
        guard let videoDuration = player.currentItem?.duration else { return }

        let playerTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerTime + duration
        newTime = clamp(minValue: 0, value: newTime, maxValue: CMTimeGetSeconds(videoDuration))
        
        let convertedtime = Int64(newTime * 1000 as Float64)
        let seekTime = CMTimeMake(value: convertedtime, timescale: 1000)
        
        player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func jumpTo(end:Bool, player: AVPlayer) {
        var time: CMTime = CMTimeMake(value: 0, timescale: 1000)

        if end, let duration = player.currentItem?.duration {
            time = duration
        }
        
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    private func clamp(minValue:Double, value:Double, maxValue:Double) -> Double {
        return min(maxValue, max(minValue, value))
    }
    
}
