//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

struct PlaybackView<T: PlaybackModelProtocol>: View {
    @EnvironmentObject var viewModel: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            
            VideoPlayer<T>()
                .environmentObject(viewModel)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            makeControls()
        }
    }
    
    
    func makeControls() -> some View {
        HStack(spacing: 32) {
            
            PlaybackControls(isPlaying: viewModel.isPlaying,
                             action: viewModel.playback)
            
            ResolutionMenu(resolution: $viewModel.resolution)
            
            VolumeControl(sliderValue: $viewModel.volumeLevel)
            
        }
        
    }

    
}

#Preview {
    PlaybackView<PlaybackModel>()
        .environment(PlaybackModel(database: PersistenceController.preview, id: UUID()))
}


