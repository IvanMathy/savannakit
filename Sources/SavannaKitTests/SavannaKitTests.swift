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
        // First refactor: 0.171 s
        // Second refactor: 0.149 s
        // Third refactor: 0.136 s
        
        measure {
            _ = lexer.getSavannaTokens(input: string)
        }
	}
    
    func testOldAlice() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "AliceInWonderland", withExtension: "txt", subdirectory: nil)
        
        let string = try! String(contentsOf: url!)
        
        let lexer = BoopLexer()
        
        // Baseline: 9s
        // First refactor: 0.253 s
        // Second refactor: 0.174 s
        
        measure {
            lexer.getSavannaTokens(input: string)
        }
    }
}
