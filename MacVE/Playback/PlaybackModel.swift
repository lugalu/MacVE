//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

@MainActor
protocol PlaybackModelProtocol: ObservableObject {
    var player: AVPlayer {get set}
    var isPlaying: Bool {get set}
    var resolution: PlaybackResolution {get set}

}



class PlaybackModel: ObservableObject, Observable, PlaybackModelProtocol {
    @Published var player: AVPlayer = AVPlayer()
    @Published var isPlaying: Bool = false
    @Published var resolution: PlaybackResolution = .fullResolution
    
    
}
