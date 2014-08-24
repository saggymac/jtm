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
    
    @IBOutlet var accountPane: AccountPaneController!
    @IBOutlet var projectsPane: ProjectsPaneController!
    
    @IBOutlet weak var toolbar: NSToolbar!
    
    func showPane( controller: NSViewController ) {
//        controller.view.frame = self.panel.contentView.bounds
        
        
        self.panel.contentView.addSubview( controller.view)
        
        var views: [NSObject:AnyObject]! = [ "pane" : controller.view ]
        
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat( "H:|-[pane]-|", options:NSLayoutFormatOptions(0), metrics: nil, views: views)
        self.panel.contentView.addConstraints( constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|-[pane]-|", options:NSLayoutFormatOptions(0), metrics: nil, views: views)
        self.panel.contentView.addConstraints( constraints)
    }
    
    
    override func awakeFromNib() {
        self.toolbar.selectedItemIdentifier = "Account"
        activateAccountPane( self)
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
