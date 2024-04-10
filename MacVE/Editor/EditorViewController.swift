//Created by Lugalu on 09/04/24.

import AppKit

class EditorMainViewController: NSViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

