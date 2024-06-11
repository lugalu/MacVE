//Created by Lugalu on 11/06/24.

import SwiftUI

enum PlaybackResolution: String, CaseIterable {
    case fullResolution = "Full"
    case halfResolution = "1/2"
    case quarterResolution = "1/4"
    case eighthResolution = "1/8"
}

struct ResolutionMenu: View {
    @Binding var resolution: PlaybackResolution
    
    var body: some View {
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

#Preview {
    ResolutionMenu(resolution: .constant(.fullResolution))
        .padding(32)
}
