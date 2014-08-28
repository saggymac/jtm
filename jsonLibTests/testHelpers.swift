//
//  testHelpers.swift
//  json
//
//  Created by Scott A. Guyer on 8/27/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Foundation


func loadResourceFile( filename: String ) -> NSData? {

    let nsString = NSString( string: filename)

    let name = nsString.stringByDeletingPathExtension
    let ext = nsString.pathExtension
    
    let bundle = NSBundle( identifier: "com.saggymac.osx.jsonLibTests")
    
    if let path = bundle.pathForResource( name, ofType: ext) {
        return NSData( contentsOfFile: path)
    }

    return nil
}