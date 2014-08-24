//
//  AccountPane.swift
//  jtm
//
//  Created by Scott A. Guyer on 8/23/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa

class AccountPaneController : NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var userTextField: NSTextField!
    @IBOutlet weak var passTextField: NSSecureTextField!
    @IBOutlet weak var verifyButton: NSButton!
    
    @IBAction func verifyAction(sender: AnyObject) {
        // TODO: this is where we need to start validating against the JIRA API
        
        let client = JIRAClient( host: "scotts-mbp.home:2990")
        
        client.authenticate( self.userTextField.stringValue, pass: self.passTextField.stringValue ) { (let object, let error) in

        }
        
    }
    
    
    func textFieldIsEmpty ( textField: NSTextField ) -> Bool {
        return textField.stringValue.lengthOfBytesUsingEncoding( NSASCIIStringEncoding) == 0
    }
    
    override func controlTextDidChange(obj: NSNotification!) {
        
        if let sender = obj.object as? NSTextField {
            verifyButton.enabled = !(textFieldIsEmpty( self.userTextField) || textFieldIsEmpty( self.passTextField))
        }
        
    }
    
}



class AccountPane : NSView {
    
}
