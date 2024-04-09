//Created by Lugalu on 09/04/24.

import AppKit
import AVKit

class EditorWindow: NSWindow{
    init () {
        super.init(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: 1200,
                height: 700
            ),
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .fullSizeContentView,
                .resizable
            ],
            backing: .buffered,
            defer: false
        )
        
        let minSize = NSSize(width: 1200, height: 700)
        
        if let screenSize = NSScreen.main?.frame.size{
            self.contentMaxSize = screenSize
            self.setFrameOrigin( NSPoint(x: abs(screenSize.width - minSize.width) / 2, y: abs(screenSize.height - minSize.height) / 2 ))
        }
        self.contentMinSize = minSize
        self.contentViewController = EditorMainViewController()
        self.title = "Project Select"
    }
}

