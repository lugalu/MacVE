//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

struct PlaybackView<T: PlaybackModelProtocol>: View {
    @EnvironmentObject var viewModel: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            
            VideoPlayer(player: $viewModel.player)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            makeControls()
        }
        .padding(8)
    }
    
    
    func makeControls() -> some View {
        HStack{
            Group{
                //TODO: remove this and insert Spacer!
                Button(action: {
                    let url = URL(filePath: "video2.mp4", directoryHint: .checkFileSystem, relativeTo: .downloadsDirectory)
                    let player = AVPlayer(url: url)
                    viewModel.player = player
                }, label: {
                    Text("Load Video")
                })
                
                PlaybackControls(isPlaying: $viewModel.isPlaying)
                
                ResolutionMenu(resolution: $viewModel.resolution)
                
                
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}

#Preview {
    PlaybackView<PlaybackModel>()
        .environment(PlaybackModel())
}


