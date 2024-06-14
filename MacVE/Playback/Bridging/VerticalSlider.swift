//Created by Lugalu on 13/06/24.

import SwiftUI
import AppKit

struct VerticalSlider: NSViewRepresentable {
    @Binding var sliderValue: Float
    var sliderRange: ClosedRange<Double>
   
    
    func makeNSView(context: Context) -> NSSlider  {
     let slider = NSSlider()
        slider.sliderType = .linear
        slider.isVertical = true
        slider.minValue = sliderRange.lowerBound
        slider.maxValue = sliderRange.upperBound
        slider.floatValue = sliderValue
        slider.target = context.coordinator
        slider.action = #selector(Coordinator.didChange(_:))
        
        
        return slider
    }
    

    
    class Coordinator {
        var parent: VerticalSlider
        
        init(_ parent: VerticalSlider) {
            self.parent = parent
        }
        
        @objc func didChange(_ sender: NSSlider?){
            guard let slider = sender else { return }
            parent.sliderValue = slider.floatValue
        }
    }
    
    func updateNSView(_ nsView: NSSlider, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

