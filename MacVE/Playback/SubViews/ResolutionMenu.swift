//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit
import Accelerate

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

class ResolutionChangerCompositor: NSObject, AVVideoCompositing {
    var sourcePixelBufferAttributes: [String : Any]? = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        
    ]
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
    ]

    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
    }
    
    private func createvImage_CGImageFormat(cvPixelBuffer: CVPixelBuffer) -> vImage_CGImageFormat? {
        let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent),
        let colorSpace = cgImage.colorSpace
        else { return nil }
        
        return vImage_CGImageFormat(bitsPerComponent: 8,
                                    bitsPerPixel: 32,
                                    colorSpace: colorSpace,
                                    bitmapInfo: cgImage.bitmapInfo)
    }
    
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        let request = asyncVideoCompositionRequest
        let instruction = request.videoCompositionInstruction
        
        guard let id = instruction.requiredSourceTrackIDs?.first as? Int32,
              let sourceBuffer = request.sourceFrame(byTrackID: id)
        else {
            request.finishCancelledRequest()
            return
        }

        let bufferWidth = CVPixelBufferGetWidth(sourceBuffer)
        let bufferHeight = CVPixelBufferGetHeight(sourceBuffer)
        
        let newWidth = Int( Float(bufferWidth) * PlaybackResolution.eighthResolution.getValue() )
        let newHeight = Int( Float(bufferHeight) * PlaybackResolution.eighthResolution.getValue() )
        
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(sourceBuffer)
        let destBufferAttributes =  [
            String(kCVPixelBufferMetalCompatibilityKey): true,
            String(kCVPixelBufferOpenGLCompatibilityKey): true,
            String(kCVPixelBufferIOSurfacePropertiesKey): [
              String(kCVPixelBufferIOSurfaceCoreAnimationCompatibilityKey): true
            ]
          ] as CFDictionary

        var destinationBuffer: CVPixelBuffer?
        let destinationResult = CVPixelBufferCreate(kCFAllocatorDefault,
                                                    newWidth,
                                                    newHeight,
                                                    sourcePixelFormat,
                                                    destBufferAttributes,
                                                    &destinationBuffer)
        guard destinationResult == kCVReturnSuccess,
              var destinationBuffer else {
            request.finishCancelledRequest()
            return
        }
        CVBufferPropagateAttachments(sourceBuffer, destinationBuffer)
        
        
        let sourceFlags = CVPixelBufferLockFlags.readOnly
        let destinationFlags = CVPixelBufferLockFlags(rawValue: 0)
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(sourceBuffer, sourceFlags) else {
            request.finishCancelledRequest()
            return
        }
        defer{ CVPixelBufferUnlockBaseAddress(sourceBuffer, sourceFlags) }
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(destinationBuffer, destinationFlags) else {
            request.finishCancelledRequest()
            return
        }
        defer{ CVPixelBufferUnlockBaseAddress(destinationBuffer, destinationFlags) }

        guard let sourceBaseAddress = CVPixelBufferGetBaseAddress(sourceBuffer),
              let destinationBaseAddress = CVPixelBufferGetBaseAddress(destinationBuffer) else {
            request.finishCancelledRequest()
            return
        }
        
        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(sourceBuffer)
        let destinationBytesPerRow = CVPixelBufferGetBytesPerRow(destinationBuffer)
        var sourceVBuffer = vImage_Buffer(data: sourceBaseAddress,
                                         height: vImagePixelCount(bufferHeight),
                                         width: vImagePixelCount(bufferWidth),
                                         rowBytes: sourceBytesPerRow)
        
        var destinationVBuffer = vImage_Buffer(data: destinationBaseAddress,
                                         height: vImagePixelCount(newHeight),
                                         width: vImagePixelCount(newWidth),
                                         rowBytes: destinationBytesPerRow)
        
        let error = vImageScale_ARGB8888(&sourceVBuffer, &destinationVBuffer, nil, vImage_Flags(kvImagePrintDiagnosticsToConsole))

        guard error == kvImageNoError else  {
            request.finishCancelledRequest()
            return
        }
        request.finish(withComposedVideoFrame: destinationBuffer)
    }
    
    func cancelAllPendingVideoCompositionRequests() {
    }
    
    
        
}
class ResolutionInstruction : AVMutableVideoCompositionInstruction{
    let trackID: CMPersistentTrackID

    override var passthroughTrackID: CMPersistentTrackID{get{return trackID}}
    override var requiredSourceTrackIDs: [NSValue]{get{return [NSNumber(value: self.trackID)]}}
    override var containsTweening: Bool{get{return false}}

    init(trackID: CMPersistentTrackID){
        self.trackID = trackID
        super.init()
    
        self.enablePostProcessing = true
    }

    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
