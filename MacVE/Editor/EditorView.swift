//Created by Lugalu on 09/04/24.

import AppKit

class EditorView: NSView {
    protocol Delegate{}
    
    var delegate: Delegate?
    
    init(delegate: Delegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = nil
    }
    
    
    
}
