//
//  Crypto_AppApp.swift
//  Crypto App
//
//  Created by Steve Pha on 1/28/23.
//

import SwiftUI

@main
struct Crypto_AppApp: App {
    
    //MARK: Linking app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//MARK: Making it as a Pure Menu bar app

//MARK: Setting up Menubar icon and Menu bar popovar aera
class AppDelegate: NSObject, ObservableObject, NSApplicationDelegate {
    //MARK: properties
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    func applicationWillFinishLaunching(_ notification: Notification) {
         setupMacMenu()
    }
    
    func setupMacMenu() {
        //MARK: Popover Properties
        popover.animates = true
        popover.behavior = .transient
        
         //MARK: Linking Swiftui view
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: Home())
        
        //MARK: Making as a key windows
        popover.contentViewController?.view.window?.makeKey()
        
        //MARK: Setting a menu bar icon and action
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button {
            menuButton.image = .init(systemSymbolName: "dollarsign.circle.fill", accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonAction(sender:))
        }
    }
    
    @objc func menuButtonAction(sender: AnyObject) {
        //MARK: Showing Closing Popover
        if popover.isShown {
            popover.performClose(sender)
        }else {
            if let menuButton = statusItem?.button{
                popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
}
