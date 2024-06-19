//Created by Lugalu on 11/06/24.

import SwiftUI
import AVKit
import Accelerate

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

class ResolutionChangerCompositor: NSObject, AVVideoCompositing {
    var sourcePixelBufferAttributes: [String : Any]? = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        
    ]
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
    ]

    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
    }
    
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        print("hello")
        let request = asyncVideoCompositionRequest
        let instruction = request.videoCompositionInstruction
        
        guard let id = instruction.requiredSourceTrackIDs?.first as? Int32,
              let frameBuffer = request.sourceFrame(byTrackID: id) else {
            request.finishCancelledRequest()
            return
        }
        let ciImage = CIImage(cvPixelBuffer: frameBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent),
        let colorSpace = cgImage.colorSpace,
        var imageFormat = vImage_CGImageFormat(bitsPerComponent: cgImage.bitsPerComponent,
                                               bitsPerPixel: cgImage.bitsPerComponent,
                                               colorSpace: colorSpace,
                                               bitmapInfo: cgImage.bitmapInfo)
        else {
            fatalError("Ops")
         //   return
        }
        let bufferWidth = CVPixelBufferGetWidth(frameBuffer)
        let bufferHeight = CVPixelBufferGetHeight(frameBuffer)
       // let bufferFormat = CVPixelBufferGetPixelFormatType(frameBuffer)
        let imageFormatPointer: UnsafeMutablePointer<vImage_CGImageFormat> = .allocate(capacity: imageFormat.componentCount)
        imageFormatPointer.initialize(from: &imageFormat, count: imageFormat.componentCount)
        
        let floatPointer: UnsafeMutablePointer<CGFloat> = .allocate(capacity: 1)
        var val:CGFloat = 0
        floatPointer.initialize(from: &val, count: 1)
        
        
        let imageBuffer: UnsafeMutablePointer<vImage_Buffer> = .allocate(capacity: bufferHeight * bufferWidth)
        vImageBuffer_InitWithCVPixelBuffer(imageBuffer, imageFormatPointer, frameBuffer, nil, floatPointer, .zero) 
        
        



        request.finish(withComposedVideoFrame: frameBuffer)
    }
    
    func cancelAllPendingVideoCompositionRequests() {
            print("hm")
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
