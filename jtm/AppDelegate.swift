//
//  AppDelegate.swift
//  jtm
//
//  Created by Scott A. Guyer on 8/23/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa
import PreferencePanes

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem! = nil
    @IBOutlet weak var window: NSWindow!
    @IBOutlet var prefsController: JTMPreferencesController!

    
    func quitApplication ( sender:AnyObject ) {
        NSApplication.sharedApplication().terminate( sender)
    }
    
    func showTasksWindow ( sender: AnyObject ) {
        self.window.orderFront( sender);
        self.window.makeKeyWindow();
        NSApp.activateIgnoringOtherApps( true)
    }
    
    func showPreferences ( sender: AnyObject ) {
        if self.prefsController == nil {
            NSBundle.mainBundle().loadNibNamed( "JTMPreferences", owner: self, topLevelObjects: nil)
        }
        
        self.prefsController.panel.makeKeyAndOrderFront( sender)
    }
    
    
    func makeStatusBarMenuItems() -> Array<NSMenuItem!> {
        return [
            NSMenuItem( title:"About JTM...", target:nil, action:"orderFrontStandardAboutPanel:", keyEquivalent:""),
            NSMenuItem( title:"Preferences...", target:self, action:"showPreferences:", keyEquivalent:","),
            NSMenuItem.separatorItem(),
            NSMenuItem( title:"Tasks", target:self, action:"showTasksWindow:", keyEquivalent:"t"),
            NSMenuItem.separatorItem(),
            NSMenuItem( title:"Quit", target:nil, action:"terminate:", keyEquivalent:"q")
        ]
    }
    
    
    override func awakeFromNib() {
        
        let menu = NSMenu( title: "JTM Menu")
        makeStatusBarMenuItems().map { menu.addItem( $0) }
        
        // The value -1 is from the C #define for NSVariableStatusItemLength
        self.statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength( -1)
        self.statusBarItem.title = "JTM"
        self.statusBarItem.highlightMode = true
        self.statusBarItem.menu = menu
    }
    
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // TODO: pause any timers
    }



}

