//Created by Lugalu on 08/04/24.

import AppKit
import AVKit

class WindowController: NSWindowController{
    
    init() {
        let window = EditorWindow()

        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
