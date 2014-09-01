//
//  streamingTests.swift
//  json
//
//  Created by Scott A. Guyer on 8/27/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa
import XCTest
import jsonLib


class streamingTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMultipart() {

        let data1 = loadResourceFile( "simpleMultipart1.json")
        let data2 = loadResourceFile( "simpleMultipart2.json")
        
        let decoder = JSDecoder()
        
        var (ctxt, result) = decoder.decodeChunk( data1, continuation: nil)
        XCTAssert( (ctxt != nil) && (result == nil), "we should get a continuation context, no result")
        
        (ctxt, result) = decoder.decodeChunk( data2, continuation: ctxt)
        XCTAssert( (ctxt == nil) && (result != nil), "we should not get a continuation, and should get a result")
        
        println( "RESULT: \(result)" )
    }


}
