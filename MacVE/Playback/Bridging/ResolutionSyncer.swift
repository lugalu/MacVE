//Created by Lugalu on 21/06/24.

import SwiftUI

class ResolutionSyncer {
    @AppStorage("resolution") static var currentResolution: PlaybackResolution = .fullResolution
    
    static func getValue() -> Float {
        return currentResolution.getValue()
    }
}

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
