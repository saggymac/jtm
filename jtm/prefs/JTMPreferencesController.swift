//
//  JTMPreferencesController.swift
//  jtm
//
//  Created by Scott A. Guyer on 8/23/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa

class JTMPreferencesController : NSObject {
    
    @IBOutlet var panel: NSPanel!
    
    @IBOutlet weak var accountPane: AccountPane!
    @IBOutlet weak var projectsPane: ProjectsPane!
    
    
    func showPane( pane: NSView ) {
        pane.frame = self.panel.contentView.bounds
        self.panel.contentView.addSubview( pane)
    }
    
    
    @IBAction func activateAccountPane(sender: AnyObject) {
        
        if self.accountPane == nil {
            NSBundle.mainBundle().loadNibNamed( "AccountPane", owner: self, topLevelObjects:nil)
        }
        
        showPane( self.accountPane)
    }
    
    
    @IBAction func activateProjectsPane(sender: AnyObject) {
        
        if self.projectsPane == nil {
            NSBundle.mainBundle().loadNibNamed( "ProjectsPane", owner: self, topLevelObjects:nil)
        }
        
        showPane( self.projectsPane)
    }
    
    
    override func validateToolbarItem(theItem: NSToolbarItem!) -> Bool {
        switch theItem.label {

            case "Account" :
                return true
            
            case "Projects" :
                return false
            
            default :
                return false
            }        
    }
    
}
