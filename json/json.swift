//
//  json.swift
//  json
//
//  Created by Scott A. Guyer on 8/25/14.
//  Copyright (c) 2014 Scott A. Guyer. All rights reserved.
//

import Foundation


class JSScanner {
    var idx: String.Index
    let str: String
    
    init( _ chunk: String ) {
        str = chunk
        idx = str.startIndex
    }
    
    func canScan() -> Bool {
        return idx < str.endIndex
    }
    
    func readCharacter() -> Character {
        let chr = str[idx]
        idx = idx.successor()
        return chr
    }
    
    func peekCharacter() -> Character {
        return str[idx]
    }
    
    func index() -> String.Index {
        return idx
    }
}


enum JSStateType: String, Printable {
    case Init = "init"
    case Key = "key"
    case Value = "value"
    case JSString = "string"
    case JSNumber = "number"
    case JSBool = "bool"
    case JSNull = "null"
    case Colon = "colon"
    case Comma = "comma"
    case Property = "prop"
    case JSObject = "object"
    case JSArray = "array"
    case Final = "final"
    
    var description : String {
        get {
            return self.toRaw()
        }
    }
}


class JSState: Printable {
    var state: JSStateType
    var str: String?
    var accum: Any? // Any of the value types: object, array, string, number
    var array: JSArray?
    var handler: JSHandler
    
    init( state aState: JSStateType, handler h: JSHandler ) {
        state = aState
        str = nil
        accum = nil
        handler = h
        array = nil
    }

    var description : String {
        get {
            return state.toRaw() + ", str: " + (str != nil ? str! : "nil") 
        }
    }  

    func append( char: Character ) {
        str?.append( char)
    }
}



typealias JSHandler = (JSContext, Character) -> Bool
typealias JSObject = [String : Any?]
typealias JSArray = Array<Any?>

//
// This is the state for the parser
// It keeps a parser state, a string accumulator, and a value accumulator
//
class JSContext {
    var stack: Array<JSState>
    
    init( state: JSState ) {
        stack = [ state ]
    }
    
    func push( state: JSState ) {
        println( "PUSH: \(state)")
        stack.append( state)
    }
    
    func pop() -> JSState? {
        if !stack.isEmpty {
            let old = stack.removeLast()
            println( "POP: \(old)")
            return old
        } else {
            return nil
        }
    }
    
    func top() -> JSState? {
        if ( stack.isEmpty ) {
            return nil
        } else {
            return stack.last
        }
    }
}




public class JSDecoder {

    init () {}
    
    
    func whitespace( char: Character ) -> Bool {
        // NOTE: I found the compiler would infloop if I tried to comma sep
        // the case values
        // Also, this is kinda the suck. But there is no nice set representation that
        // I have seen for swift yet.
        switch char {
        case " ":
            return true
        case "\t":
            return true
        case "\n":
            return true
        case "\r":
            return true
        default:
            return false
        }
    }


    func endValue( context: JSContext ) -> Bool {
        // We just finished a string, number, or other value type
        // Now we roll up the data

        var valueContext = context.pop()
        
        if var top = context.top() {
            
            switch top.state {
            case .JSObject:
                if var dict = top.accum as? JSObject {
                    if let key = top.str {
                        dict[ key] = valueContext?.accum
                        top.accum = dict
                        top.str = nil
                        var newState = JSState( state: .Comma, handler:commaHandler)
                        context.push( newState)
                        return true
                    }                    
                }                

            case .JSArray:

                top.array?.append( valueContext?.accum)
                var newState = JSState( state: .Comma, handler:commaHandler)
                context.push( newState)                                      
                return true


            default:
                return false
            }

        }
        
        return false
    }
    
    
 


    func endContainer( context: JSContext ) -> Bool {

        var objContext = context.pop()!

        if var top = context.top() {
            switch top.state {
            case .JSObject:
                if var obj = top.accum as? JSObject {
                    if let key = top.str {
                        
                        obj[ key] = ( (objContext.array != nil) ? objContext.array : objContext.accum )
                        top.str = nil
                        top.accum = obj
                        var newState = JSState( state: .Comma, handler:commaHandler)
                        context.push( newState)
                        return true
                    }
                }                

            case .JSArray:
                if var arr = top.accum as? JSArray {
                    arr.append( ( (objContext.array != nil) ? objContext.array : objContext.accum ))
                    var newState = JSState( state: .Comma, handler:commaHandler)
                    context.push( newState)
                    return true
                }


            case .Value:
                context.pop()
                context.push( objContext)
                return endContainer( context)


            case .Init:
                top.array = objContext.array
                top.accum = objContext.accum
                top.state = .Final
                top.handler = finalHandler
                return true

            default:
                return false
            }
        }
        

        return false
    }
    

    func commaHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        // TODO: if looking for a comma, we could see a comma, or an 
        // end object character. for either array or object/dicts

        // If we got here, we just finished a valueHandler, and that was
        // either for a dictionary or an array. 

        switch char {
            
        case ",":
            context.pop() // pop this comma state
            if let top = context.top() {
                switch top.state {
                case .JSObject:
                    top.handler = keyHandler
                case .JSArray:
                    var valContext = JSState( state: JSStateType.Value, handler:valueHandler)
                    context.push( valContext)
                default:
                    return false
                }
            }
    

        case "}":
            context.pop()        
            return endContainer( context)

        case "]":
            context.pop()
            return endContainer( context)


        case let s where whitespace(s):
            break // eat it


        default:
            return false
        }


        return true
    }


    func finalHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")        
        switch char {

        case let s where whitespace(s):
            return true
            
        default:
            println( "trailing junk: \(char)")
            return false
        }
    }


    func stringHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        switch char {
        case "\"" :
            var strContext = context.pop()
            if var top = context.top() {
                top.accum = strContext?.str
                return endValue( context)
            }

        case let s where whitespace(s):
            break
            
        default:
            if var state = context.top() {
                state.append( char)
            }
        }
        
        return true
    }


    func literalHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        if var top = context.top() {
            let literal = top.accum! as String
            top.append( char)

            if literal == top.str! {
                context.pop() 
                if var top = context.top() {

                    switch literal {
                    case "null":
                        top.accum = nil
                    case "true":
                        top.accum = true
                    case "false":
                        top.accum = false
                    default:
                        println("unknown literal")
                        return false
                    }

                    // store nil value in the value context 
                    // and let the endValue() function clean up
                
                    return endValue( context)                    
                }
                
            }

            if  literal.hasPrefix( top.str!) {                
                return true
            } else {
                println( "unexpected character \(char) while scanning for \(top.accum)")
                return false
            }
        }
        
        return false        
    }



    func valueHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        switch char {

        case "\"": 
            var strContext = JSState( state: JSStateType.JSString, handler: stringHandler)
            strContext.str = ""
            context.push( strContext)

        case "{":
            var objContext = JSState( state: JSStateType.JSObject, objectHandler)
            objContext.accum = JSObject()
            context.push( objContext)
        
        case "[":
            var arrContext = JSState( state: JSStateType.JSArray, commaHandler)
            arrContext.array = JSArray()
            context.push( arrContext)
            var valContext = JSState( state: JSStateType.Value, valueHandler)
            context.push( valContext)


        case "t":
            var ctxt = JSState( state: .JSNull, handler: literalHandler)
            ctxt.accum = "true"
            ctxt.str = "t"
            context.push( ctxt)                            

        case "f":
            var ctxt = JSState( state: .JSNull, handler: literalHandler)
            ctxt.accum = "false"
            ctxt.str = "f"
            context.push( ctxt)                    

        case "n":
            var ctxt = JSState( state: .JSNull, handler: literalHandler)
            ctxt.accum = "null"
            ctxt.str = "n"
            context.push( ctxt)
            

        // TODO: add some recognizers for number
        

        case let s where whitespace(s):
            break

        default:
            return false
        }

        return true
    }
    
    func colonHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        switch char {
        case ":":
            var valContext = JSState( state: JSStateType.Value, handler: valueHandler)
            context.push( valContext)

        case let s where whitespace(s):
            break

        default:
            println( "unexpetcted character: \(char)")
            return false
        }

        return true
    }
    
    func keyHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        switch char {
        case "\"" :
            let keyContext = context.pop()
            if var objContext = context.top() {
                objContext.str = keyContext?.str
                objContext.handler = colonHandler
            }

        case let s where whitespace(s):
            break
            
        default:
            if var state = context.top() {
                state.append( char)
            }
        }
        
        return true
    }
    
    
    func objectHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")

        switch char {

        case "}":
            return endContainer( context)
        
        case "\"":
            var keyCtxt = JSState( state: JSStateType.Key, keyHandler)
            keyCtxt.str = String()
            context.push( keyCtxt)

            
        case let s where whitespace(s):
            break

        default:
            println( "unexpected character")
            return false
        }
        
        return true
    }
        

 
    // In the initial state, we are eaching whitespace and looking for an
    // opening "{" or "[" character
    //
    func initialHandler( context: JSContext, char: Character ) -> Bool {
        println( "\(__FUNCTION__)(\(char))")
 
        switch char {

        case "{":
            var objContext = JSState( state: JSStateType.JSObject, objectHandler)
            objContext.accum = JSObject()
            context.push( objContext)
        
        case "[":
            var arrContext = JSState( state: JSStateType.JSArray, commaHandler)
            arrContext.array = JSArray()
            context.push( arrContext)
            var valContext = JSState( state: JSStateType.Value, valueHandler)
            context.push( valContext)

            
        case let s where whitespace(s):
            break
        
        default:
            println( "unexpected character")
            return false
        }
        
        return true
    }
    
    
    
    func decode( someData: NSData! ) -> Any? {
        
        let str = NSString( data: someData, encoding: NSUTF8StringEncoding) as String
        let s = JSScanner( str)
        
        println( "JSON: \(str)")
        
        var startState = JSState( state: JSStateType.Init, handler: initialHandler)
        var ctxt = JSContext( state: startState)
        
        while ( s.canScan() ) {
            let ch = s.readCharacter()
            
                if let currentState = ctxt.top() {
                if !currentState.handler( ctxt, ch) {
                    println( "error")
                    break
                }
            }
        }
        
        
        // Final state check
        var result: Any? = nil
        if let currentState = ctxt.top() {
            if ( currentState.state == JSStateType.Final ) {
                
                if let a = currentState.array {
                    result = a
                }

                if let d = currentState.accum {
                    result = d
                }
            }
        }

        return result
    }
    
}
