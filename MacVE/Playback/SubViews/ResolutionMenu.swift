//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit

@available(*, deprecated, message: "unused for now")
enum PlaybackResolution: String, CaseIterable {
    case fullResolution = "Full"
    case halfResolution = "1/2"
    case quarterResolution = "1/4"
    case eighthResolution = "1/8"
    
    
    func getValue() -> Float{
        return switch self {
        case .fullResolution:
            1.0
        case .halfResolution:
            0.5
        case .quarterResolution:
            0.25
        case .eighthResolution:
            0.125
        }
    }
}

@available(*, deprecated, message: "unused for now")
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

class ResolutionChanger: NSObject, AVVideoCompositing {
    var sourcePixelBufferAttributes: [String : Any]? = [
        String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32ARGB,
        
    ]
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [:]
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        let test = newRenderContext.newPixelBuffer()
        
        
    }
    
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        asyncVideoCompositionRequest.renderContext.newPixelBuffer()
        
    }
    
}
