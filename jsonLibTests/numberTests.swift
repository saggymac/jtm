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


    func testFloat() {
        var result: Any? = nil
        
        if let data = loadResourceFile( "float.json") {
            let p = JSDecoder()
            result = p.decode( data)
        }
        
        XCTAssert( result != nil, "we expect a non-nil result")
        XCTAssert( result! is JSArray, "we expected an array")
        
        let arr = result as JSArray
        XCTAssert( arr.count == 1, "we expected a value")
        
        let numberValue = arr[0] as Any?
        XCTAssert( numberValue != nil, "we expected a non-nil value")

        XCTAssert( numberValue is Double, "we expected a Double value")
        let value = numberValue as Double
        XCTAssert( value == 1.23, "we expected 1.23")
    }
    
    

    func testDecimal() {
        var result: Any? = nil
        
        if let data = loadResourceFile( "decimal.json") {
            let p = JSDecoder()
            result = p.decode( data)
        }
        
        XCTAssert( result != nil, "we expect a non-nil result")
        XCTAssert( result! is JSArray, "we expected an array")
        
        let arr = result as JSArray
        XCTAssert( arr.count == 1, "we expected a value")
        
        let numberValue = arr[0] as Any?
        XCTAssert( numberValue != nil, "we expected a non-nil value")
        
        XCTAssert( numberValue is Double, "we expected a Double value")
        let value = numberValue as Double
        XCTAssert( value == 12300, "we expected 12300")
    }

    func validateNumber( should: Double, _ val: Any? ) {


        XCTAssert( val != nil, "we expected a non-nil value")        


        XCTAssert( val is Double, "we expected a Double value")
        let value = val as Double
        XCTAssert( value == should, "we expected \(should)")        
    }

    func testZeros() {
        var result: Any? = nil
        
        if let data = loadResourceFile( "zeros.json") {
            let p = JSDecoder()
            result = p.decode( data)
        }
        
        XCTAssert( result != nil, "we expect a non-nil result")
        XCTAssert( result! is JSArray, "we expected an array")
        
        let arr = result as JSArray
        XCTAssert( arr.count == 4, "we expected a value")
        
        validateNumber( 0, arr[0])
        validateNumber( 0.1, arr[1])
        validateNumber( 20, arr[2])
        validateNumber( 0, arr[3])

    }


    func testTrailingComma() {
        var result: Any? = nil
        
        if let data = loadResourceFile( "numberWithTrailingComma.json") {
            let p = JSDecoder()
            result = p.decode( data)
        }
        
        XCTAssert( result != nil, "we expect a non-nil result")
        XCTAssert( result! is JSArray, "we expected an array")
        
        let arr = result as JSArray
        XCTAssert( arr.count == 2, "we expected a value")

        validateNumber( 1, arr[0])
        validateNumber( 2, arr[1])

    }


}
