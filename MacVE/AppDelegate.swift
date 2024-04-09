//Created by Lugalu on 08/04/24.

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenuItem()
        menu.submenu = NSMenu()
        menu.submenu?.addItem(NSMenuItem(title: "Quit",
                                         action: #selector(NSApplication.terminate(_:)),
                                         keyEquivalent: "q")
        )
        let mainMenu = NSMenu(title: "MacVE")
        mainMenu.addItem(menu)
        
        NSApplication.shared.mainMenu = mainMenu
        
        let minSize = NSSize(width: 1200, height: 700)
        
        let window = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: 1200,
                height: 700
            ),
            styleMask: [
                .titled,
                .closable,
                .fullSizeContentView,
                .resizable
            ],
            backing: .buffered,
            defer: false
        )
        window.minSize = minSize
        //
                
        if let size = NSScreen.main?.frame.size {
            window.maxSize = size
           // window.setFrameTopLeftPoint(NSPoint(x: abs(size.width - minSize.width / 4), y: abs(size.height - minSize.height)))
            window.setFrameOrigin( NSPoint(x: abs(size.width - minSize.width) / 2, y: abs(size.height - minSize.height) / 2 ))

        }
        
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

