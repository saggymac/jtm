// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
str.append( "!" as Character)
str

struct Test {
    var str: String?
    
    init() {
        str = ""
    }
}

var t = Test()
t.str = ""

t.str?.append( "D" as Character)
t.str?

var list = [ t ]

list.last?.str?.append( "E" as Character)

t.str?






