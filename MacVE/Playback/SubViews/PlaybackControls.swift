//Created by Lugalu on 11/06/24.

import SwiftUI

struct PlaybackControls: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        HStack(spacing: 10){
            Group{
                Button(action: {}, label: {
                    Image(systemName: "backward.end.fill")
                })
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "backward.fill")
                })
                Button(action: {
                    isPlaying.toggle()
                }, label: {
                    
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                })
                Button(action: {}, label: {
                    Image(systemName: "forward.fill")
                })
                Button(action: {}, label: {
                    Image(systemName: "forward.end.fill")
                })
                
            }
            .buttonStyle(PlainButtonStyle())
        }
        
    }
}

#Preview {
    PlaybackControls(isPlaying: .constant(true))
}
