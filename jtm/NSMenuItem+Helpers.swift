//
//  NSMenuItem+Helpers.swift
//  JIRATaskMaster
//
//  Created by Scott A. Guyer on 8/22/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa

extension NSMenuItem {

    convenience init ( title aString: NSString,
                       target aTarget: AnyObject?,
                       action aSelector: Selector = nil,
                       keyEquivalent keyCode: String = "" ) {

        self.init( title: aString, action: aSelector, keyEquivalent: keyCode)
        if let t: AnyObject = aTarget {
            self.target = t
        }
    }

}
