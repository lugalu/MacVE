//Created by Lugalu on 13/06/24.

import SwiftUI

struct VolumeControl: View {
    @Binding var sliderValue: Float
    @State private var isShowingSlider: Bool = false
    
    var body: some View {
        Group{
            Label("", systemImage: getIconName())
                .labelStyle(.iconOnly)
                .frame(width: 20, height: 20)
                .padding(5)

                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.gray.opacity(0.3))
                }
                .overlay(alignment: .bottom) {
                    if isShowingSlider {
                        VerticalSlider(sliderValue: $sliderValue,
                                       sliderRange: 0...1)
                        .frame(width: 20, height: 50, alignment: .bottom)
                        .background(.gray.opacity(0.3))
                        .clipShape(
                            .rect(
                                topLeadingRadius: 8,
                                topTrailingRadius: 8
                            )
                        )
                        .offset(y: -30)
                    }
                }
        }
        .onHover{ hovering in
            isShowingSlider = hovering
        }
    }
    
    private func getIconName() -> String {
        return switch sliderValue {
        case 0:
            "speaker.slash.fill"
        case ...0.33:
            "speaker.wave.1.fill"
        case ...0.75:
            "speaker.wave.2.fill"
        default:
            "speaker.wave.3.fill"
        }
    }
}

#Preview {
    VolumeControl(sliderValue: .constant(0.2))
}
