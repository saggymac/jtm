//
//  AccountPane.swift
//  jtm
//
//  Created by Scott A. Guyer on 8/23/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa

class AccountPaneController : NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var hostTextField: NSTextField!
    @IBOutlet weak var userTextField: NSTextField!
    @IBOutlet weak var passTextField: NSSecureTextField!
    @IBOutlet weak var verifyButton: NSButton!
    @IBOutlet weak var verifiedIcon: NSImageView!
    
    // TODO: restore the view with persisted data if there is any
    
    override func awakeFromNib() {
        self.verifiedIcon.hidden = true
    }

    
    @IBAction func verifyAction(sender: AnyObject) {
        // "scotts-mbp.home:2990"
        let client = JIRAClient( host: hostTextField.stringValue)
        
        client.authenticate( self.userTextField.stringValue, pass: self.passTextField.stringValue ) { (let object, let error) in

            // TODO: let the other Projects pane be active
            self.verifiedIcon.hidden = false
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
