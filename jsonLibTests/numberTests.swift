//
//  numberTests.swift
//  json
//
//  Created by Scott A. Guyer on 8/28/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Cocoa
import XCTest
import jsonLib



class numberTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {

        super.tearDown()
    }

    
    func testInteger() {
        
        var result: Any? = nil
        
        if let data = loadResourceFile( "int.json") {
            let p = JSDecoder()
            result = p.decode( data)
        }
        
        XCTAssert( result != nil, "we expect a non-nil result")
        XCTAssert( result! is JSArray, "we expected an array")
        
        let arr = result as JSArray
        XCTAssert( arr.count == 1, "we expected a value")
        
        let integerValue = arr[0] as Any?
        XCTAssert( integerValue != nil, "we expected a non-nil value")

        XCTAssert( integerValue is Double, "we expected a Double value")
        let value = integerValue as Double
        XCTAssert( value == 123, "we expected 123")
    }


}
