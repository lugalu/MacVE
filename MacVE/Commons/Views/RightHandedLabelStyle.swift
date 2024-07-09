//Created by Lugalu on 09/07/24.

import SwiftUI


public extension LabelStyle where Self == RightHandedLabelStyle {
    static var rightHanded: RightHandedLabelStyle {
        return RightHandedLabelStyle()
    }
}
public struct RightHandedLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack{
            configuration.title
            configuration.icon
        }
    }
}
#Preview {
    Label("Open From Disk", systemImage: "folder.fill")
        .labelStyle(.rightHanded)
}
