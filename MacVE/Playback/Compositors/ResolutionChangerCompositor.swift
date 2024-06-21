//Created by Lugalu on 21/06/24.

import AVKit
import Accelerate

class ResolutionChangerCompositor: NSObject, AVVideoCompositing {
    var sourcePixelBufferAttributes: [String : Any]? = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        
    ]
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
    ]

    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
    }
    
    private func getStandardBufferAttributes() -> CFDictionary {
        return [
            String(kCVPixelBufferMetalCompatibilityKey): true,
            String(kCVPixelBufferOpenGLCompatibilityKey): true,
            String(kCVPixelBufferIOSurfacePropertiesKey): [
              String(kCVPixelBufferIOSurfaceCoreAnimationCompatibilityKey): true
            ]
        ] as CFDictionary
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
        
        let scalar = ResolutionSyncer.getValue()
        
        guard scalar != 1 else {
            request.finish(withComposedVideoFrame: sourceBuffer)
            return
        }
        
        let destinationBuffer = downscale(sourceBuffer: sourceBuffer, scalar: scalar)
        request.finish(withComposedVideoFrame: destinationBuffer)
    }
    
    private func downscale(sourceBuffer: CVPixelBuffer, scalar: Float) -> CVPixelBuffer {

        let bufferWidth = CVPixelBufferGetWidth(sourceBuffer)
        let bufferHeight = CVPixelBufferGetHeight(sourceBuffer)
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(sourceBuffer)
        let sourceFlags = CVPixelBufferLockFlags.readOnly

        let newWidth = Int(Float(bufferWidth) * scalar)
        let newHeight = Int(Float(bufferHeight) * scalar)
        let destBufferAttributes: CFDictionary = getStandardBufferAttributes()
        let destinationFlags = CVPixelBufferLockFlags(rawValue: 0)
        var destinationBuffer: CVPixelBuffer?

        guard
            kCVReturnSuccess == CVPixelBufferCreate(kCFAllocatorDefault,
                                                      newWidth,
                                                      newHeight,
                                                      sourcePixelFormat,
                                                      destBufferAttributes,
                                                      &destinationBuffer),
            let destinationBuffer
        else {
            return sourceBuffer
        }
        CVBufferPropagateAttachments(sourceBuffer, destinationBuffer)
                
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(sourceBuffer, sourceFlags) else {
            return sourceBuffer
        }
        defer{ CVPixelBufferUnlockBaseAddress(sourceBuffer, sourceFlags) }
        
        
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(destinationBuffer, destinationFlags) else {
            return sourceBuffer
        }
        defer{ CVPixelBufferUnlockBaseAddress(destinationBuffer, destinationFlags) }

        
        guard let sourceBaseAddress = CVPixelBufferGetBaseAddress(sourceBuffer),
              let destinationBaseAddress = CVPixelBufferGetBaseAddress(destinationBuffer) else {
            return sourceBuffer
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
            return sourceBuffer
        }
        
        return destinationBuffer
    }
    

        
}

//
//class ResolutionInstruction : AVMutableVideoCompositionInstruction{
//    let trackID: CMPersistentTrackID
//
//    override var passthroughTrackID: CMPersistentTrackID{get{return trackID}}
//    override var requiredSourceTrackIDs: [NSValue]{get{return [NSNumber(value: self.trackID)]}}
//    override var containsTweening: Bool{get{return false}}
//
//    init(trackID: CMPersistentTrackID){
//        self.trackID = trackID
//        super.init()
//    
//        self.enablePostProcessing = true
//    }
//
//    required init?(coder aDecoder: NSCoder){
//        fatalError("init(coder:) has not been implemented")
//    }
//}
