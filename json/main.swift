//
//  main.swift
//  json
//
//  Created by Scott A. Guyer on 8/25/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Foundation
import jsonLib

let data = NSData( contentsOfFile: "/Users/saguyer/src/json/test/objectInArray.json")
let p = JSDecoder()	
if let result = p.decode( data) {
    println( "RESULT: \(result)")    
}




