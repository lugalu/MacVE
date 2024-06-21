//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit
import Accelerate

struct ResolutionMenu: View {
    @Binding var resolution: PlaybackResolution
    
    var body: some View {
        HStack {
            Text("Resolution:")
            Menu {
                ForEach(PlaybackResolution.allCases, id: \.self){ value in
                    Button(action: {
                        resolution = value
                    }, label: {
                        Text(value.rawValue)
                    })
                }
            } label: {
                
                Label(resolution.rawValue, systemImage: "")
                    .labelStyle(.titleOnly)
            }
            .menuStyle(.button)
            .frame(width: 160)
        }
    }
}

