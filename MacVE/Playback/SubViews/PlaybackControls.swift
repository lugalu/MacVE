//Created by Lugalu on 11/06/24.

import SwiftUI

enum PlaybackCommands {
    case backward
    case backwardEnd
    case playPause
    case foward
    case fowardEnd
}

struct PlaybackControls: View {
    var isPlaying: Bool
    var action: (PlaybackCommands) -> Void
    
    var body: some View {
        HStack() {
            Group{
                Button(action: {
                    action(.backwardEnd)
                }, label: {
                    Image(systemName: "backward.end.fill")
                })
                
                Button(action: {
                    action(.backward)
                    
                }, label: {
                    Image(systemName: "backward.fill")
                })
                
                Button(action: {
                    action(.playPause)
                }, label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                })
                
                Button(action: {
                    action(.foward)
                }, label: {
                    Image(systemName: "forward.fill")
                })
                
                Button(action: {
                    action(.fowardEnd)
                }, label: {
                    Image(systemName: "forward.end.fill")
                })
                
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
        
}

#Preview {
    PlaybackControls(isPlaying: true, action: {_ in})
}
