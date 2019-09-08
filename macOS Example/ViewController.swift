//
//  ViewController.swift
//  macOS Example
//
//  Created by Ivan on 5/9/19.
//  Copyright © 2019 Silver Fox. All rights reserved.
//

import Foundation
import SavannaKit
import AppKit

class MacViewController: NSViewController {
    
    @IBOutlet weak var syntaxTextView: SyntaxTextView!
    
    let lexer = MyLexer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syntaxTextView.delegate = self
        syntaxTextView.theme = MyTheme()
        
        syntaxTextView.text = """
        This is an example of SavannaKit.
        This example highlights words that are longer than 6 characters in red.
        """
        
    }
    
}

extension MacViewController: SyntaxTextViewDelegate {
    
    public func didChangeText(_ syntaxTextView: SyntaxTextView) {
        
        
    }
    
    public func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {
        
        
    }
    
    public func lexerForSource(_ source: String) -> Lexer {
        return lexer
    }
    
}

class MyLexer: Lexer {
    
    init() {
        
    }
    
    func getSavannaTokens(input: String) -> [Token] {
        
        var tokens = [MyToken]()
        
        input.enumerateSubstrings(in: input.startIndex..<input.endIndex, options: [.byWords]) { (word, range, _, _) in
            
            if let word = word {
                
                let type: MyTokenType
                
                if word.count > 6 {
                    type = .longWord
                } else {
                    type = .shortWord
                }
                
                let token = MyToken(type: type, isEditorPlaceholder: false, isPlain: false, range: range)
                
                tokens.append(token)
                
            }
            
        }
        
        return tokens
    }
    
}

enum MyTokenType {
    case longWord
    case shortWord
}

struct MyToken: Token {
    
    let type: MyTokenType
    
    let isEditorPlaceholder: Bool
    
    let isPlain: Bool
    
    let range: Range<String.Index>
    
}

class MyTheme: SyntaxColorTheme {
    
    private static var lineNumbersColor: Color {
        return Color(red: 85/255, green: 86/255, blue: 100/255, alpha: 1.0)
    }
    
    let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 16)!, textColor: lineNumbersColor)
    let gutterStyle: GutterStyle = GutterStyle(
        backgroundColor: Color(red: 21/255.0, green: 22/255, blue: 31/255, alpha: 1.0),
        separatorColor: Color(red: 15/255.0, green: 16/255, blue: 20/255, alpha: 1.0),
        minimumWidth: 40)
    
    let font = Font(name: "Menlo", size: 15)!
    
    let backgroundColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
    
    func globalAttributes() -> [NSAttributedString.Key: Any] {
        
        var attributes = [NSAttributedString.Key: Any]()
        
        attributes[.font] = Font(name: "Menlo", size: 15)!
        attributes[.foregroundColor] = NSColor.white
        
        return attributes
    }
    
    func attributes(for token: Token) -> [NSAttributedString.Key: Any] {
        
        guard let myToken = token as? MyToken else {
            return [:]
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        
        switch myToken.type {
        case .longWord:
            attributes[.foregroundColor] = NSColor.red
            
        case .shortWord:
            attributes[.foregroundColor] = NSColor.white
            
        }
        
        return attributes
    }
    
}
