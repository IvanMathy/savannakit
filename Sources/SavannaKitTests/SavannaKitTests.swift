//
//  SavannaKitTests.swift
//  SavannaKitTests
//
//  Created by Louis D'hauwe on 02/05/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import XCTest
@testable import SavannaKit
import Foundation

class SavannaKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testOldGit() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "BoopGithub", withExtension: "html", subdirectory: nil)
        
        let string = try! String(contentsOf: url!)
        
        let lexer = BoopLexer()
        
        // First run: 43s
        
        measure {
            lexer.getSavannaTokens(input: string)
        }
	}
    
    func testOldAlice() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "AliceInWonderland", withExtension: "txt", subdirectory: nil)
        
        let string = try! String(contentsOf: url!)
        
        let lexer = BoopLexer()
        
        // Baseline: 9s
        
        measure {
            lexer.getSavannaTokens(input: string)
        }
    }
    
    
}
