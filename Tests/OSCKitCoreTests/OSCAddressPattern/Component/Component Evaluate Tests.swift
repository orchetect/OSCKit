//
//  Component Evaluate Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCAddressPattern_Component_Evaluate_Individual_Pattern_Types_Tests {
    @Test
    func emptyPattern() {
        #expect(
            !OSCAddressPattern.Component(string: "").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "").evaluate(matching: "")
        )
    }
    
    @Test
    func basicLiterals() {
        #expect(
            OSCAddressPattern.Component(string: "123").evaluate(matching: "123")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "123").evaluate(matching: "ABC")
        )
        
        // edge cases
        
        #expect(
            !OSCAddressPattern.Component(string: "12").evaluate(matching: "123")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "1234").evaluate(matching: "123")
        )
    }
    
    @Test
    func variableWildcard() {
        #expect(
            OSCAddressPattern.Component(string: "*").evaluate(matching: "1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "1*").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "12*").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "123*").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*3").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*23").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*123").evaluate(matching: "123")
        )
    }
    
    @Test
    func variableWildcard_EdgeCases() {
        #expect(
            OSCAddressPattern.Component(string: "***").evaluate(matching: "1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "****").evaluate(matching: "123")
        )
    }
    
    @Test
    func singleWildcard() {
        #expect(
            OSCAddressPattern.Component(string: "?").evaluate(matching: "1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "?").evaluate(matching: "123")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "???").evaluate(matching: "123")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "????").evaluate(matching: "123")
        )
    }
    
    @Test
    func bracket() {
        // single chars
        
        #expect(
            OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "c")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "d")
        )
        
        // range
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z]").evaluate(matching: "z")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "C")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "z")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "bb")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "ab")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "-")
        )
        
        // single-member range
        
        #expect(
            OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "b")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "c")
        )
        
        // invalid range
        
        #expect(
            !OSCAddressPattern.Component(string: "[y-b]").evaluate(matching: "c")
        )
        
        // mixed ranges
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "Z")
        )
        
        // mixed singles and ranges
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "X")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "X")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "Y")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "Z")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "A")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "-")
        )
        
        // edge cases
        
        #expect(
            OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "-")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "z")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "-")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "y")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "-")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "y")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "-")
        )
    }
    
    @Test
    func bracket_isExcluded_SingleChars() {
        // single chars
        
        #expect(
            !OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "c")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "d")
        )
    }
    
    @Test
    func bracket_isExcluded_Range() {
        #expect(
            !OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "b")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "y")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "z")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "B")
        )
    }
    
    @Test
    func bracket_SingleMemberRange() {
        #expect(
            !OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "c")
        )
    }
    
    @Test
    func bracket_MixedRanges() {
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "A")
        )
    }
    
    @Test
    func bracket_EdgeCases() {
        // invalid range
        
        #expect(
            OSCAddressPattern.Component(string: "[!y-b]").evaluate(matching: "c")
        )
        
        // edge cases
        
        #expect(
            !OSCAddressPattern.Component(string: "[!]").evaluate(matching: "")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!!]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!!]").evaluate(matching: "!")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!!a]").evaluate(matching: "a")
        )
    }
    
    @Test
    func bracket_MixedSinglesAndRanges() {
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "x")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "X")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "A")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "Z")
        )
    }
    
    @Test
    func brace() {
        #expect(
            OSCAddressPattern.Component(string: "{abc}").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{abc,def}").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{def,abc}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{def}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{def,ghi}").evaluate(matching: "abc")
        )
    }
    
    @Test
    func brace_EdgeCases() {
        #expect(
            OSCAddressPattern.Component(string: "{,abc}").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{abc,}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{,abc}").evaluate(matching: "")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{abc,}").evaluate(matching: "")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{}").evaluate(matching: "")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{,}").evaluate(matching: "")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{}abc").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{,}abc").evaluate(matching: "abc")
        )
    }
    
    @Test
    func brace_Malformed_A() {
        #expect(
            OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "{abc,def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "def")
        )
    }
    
    @Test
    func brace_Malformed_B() {
        #expect(
            OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "}abc,def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "def")
        )
    }
    
    @Test
    func brace_Malformed_C() {
        #expect(
            OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "{{abc,def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "def")
        )
    }
    
    @Test
    func brace_Malformed_D() {
        #expect(
            OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "abc,def}")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "def")
        )
    }
    
    @Test
    func bracketsAndBraces() {
        #expect(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1ABC")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "zabc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1abcz")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "abc")
        )
    }
}

@Suite struct OSCAddressPattern_Component_Evaluate_Complex_Patterns_Tests {
    @Test
    func complex_A() {
        // abc*
        
        #expect(
            OSCAddressPattern.Component(string: "abc*").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "abc*").evaluate(matching: "abcd")
        )
    }
    
    @Test
    func complex_B() {
        // *abc
        
        #expect(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xabc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyabc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc").evaluate(matching: "abc1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyabc1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyABC")
        )
    }
    
    @Test
    func complex_C() {
        // *abc*
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "abcd")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xabc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xabcd")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xyabcde")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xyABCde")
        )
    }
    
    @Test
    func complex_D() {
        // *a*bc*
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a1bc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "abc1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1a1bc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a1bc1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1a1bc1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "bc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "bca")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "ABC")
        )
    }
    
    @Test
    func complex_E() {
        // abc*{def,xyz}[0-9]
        
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcXxyz2")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]")
                .evaluate(matching: "abcXXxyz2")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcxyzX")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]")
                .evaluate(matching: "dummyName123")
        )
    }
    
    @Test
    func complex_F() {
        // *abc{def,xyz}[0-9]
        
        #expect(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "Xabcdef1")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]")
                .evaluate(matching: "XXabcdef1")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdefX")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1X")
        )
    }
    
    @Test
    func complex_G() {
        // abc*{def,xyz}[A-F0-9][A-F0-9]
        
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcdef7F")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcXdefF7")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcdefFG")
        )
    }
    
    @Test
    func complex_EdgeCases_WildcardInBrackets() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        #expect(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "*")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "c")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "x")
        )
    }
    
    @Test
    func complex_EdgeCases_SingleWildcardInBrackets() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        #expect(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "?")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "a")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "b")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "c")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "x")
        )
    }
    
    @Test
    func complex_EdgeCases_WildcardInBraces() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        #expect(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "*abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "xabc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "xxabc")
        )
    }
    
    @Test
    func complex_EdgeCases_SingleWildcardInBraces() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        #expect(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "?abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "abc")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "xabc")
        )
    }
    
    @Test
    func complex_EdgeCases_ExclamationPointInBraces() {
        // test the use of ! within brackets.
        // according to the OSC 1.0 spec, ! is only valid if used as the first
        // character within a [] bracketed expression, not within braces {}
        
        #expect(
            OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "!abc")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "def")
        )
        
        #expect(
            !OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "abc")
        )
    }
    
    @Test
    func edgeCases_CommonSymbols() {
        #expect(
            OSCAddressPattern.Component(string: "vol-").evaluate(matching: "vol-")
        )
        
        #expect(
            OSCAddressPattern.Component(string: "vol+").evaluate(matching: "vol+")
        )
        
        #expect(
            OSCAddressPattern.Component(string: ##"`!@#$%^&()-_=+,./<>;':"\|"##)
                .evaluate(matching: ##"`!@#$%^&()-_=+,./<>;':"\|"##)
        )
    }
}
