//Created by Lugalu on 08/04/24.

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenuItem()
        let quit = NSMenuItem(
            title: "Quit",
            action: #selector(
                NSApplication.terminate(_:)
            ),
            keyEquivalent:"q"
        )
        quit.keyEquivalentModifierMask = .command
        
        
        menu.submenu = NSMenu()
        menu.submenu?.addItem(quit)
        
        let mainMenu = NSMenu(title: "MacVE")
        mainMenu.addItem(menu)
        
        NSApplication.shared.mainMenu = mainMenu
        
        let wc = WindowController()
        wc.window?.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
}

