//
//  InnerTextView.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 09/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

protocol InnerTextViewDelegate: class {
	func didUpdateCursorFloatingState()
}

final class InnerTextView: NSTextView {
	
	weak var innerDelegate: InnerTextViewDelegate?
	
	var theme: SyntaxColorTheme?
	
	var cachedParagraphs: [Paragraph]?
    
    var autocompleteWords: [String]?
	
	func invalidateCachedParagraphs() {
		cachedParagraphs = nil
	}
	
	func hideGutter() {
		gutterWidth = theme?.gutterStyle.minimumWidth ?? 0.0
	}
	
	func updateGutterWidth(for numberOfCharacters: Int) {
		
		let leftInset: CGFloat = 4.0
		let rightInset: CGFloat = 4.0
		
		let charWidth: CGFloat = 10.0
		
		gutterWidth = max(theme?.gutterStyle.minimumWidth ?? 0.0, CGFloat(numberOfCharacters) * charWidth + leftInset + rightInset)
		
	}
	
	var gutterWidth: CGFloat {
		set {
            textContainerInset = NSSize(width: newValue, height: 0)
		}
		get {
            return textContainerInset.width
		}
	}
    
    override func didChangeText() {
        
        super.didChangeText()
        
        // Invoke lint after two second delay
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(complete(_:)), with: nil, afterDelay: 0.5)
    }
    
    /// Autocomplete
    override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
        
        guard charRange.length > 0, let range = Range(charRange, in: text) else { return nil }
        
        var wordList = [String]()
        let partialWord = String(text[range])

        // Add words in the document
        let documentWords: [String] = {
            // do nothing if the particle word is a symbol
            guard charRange.length > 1 || CharacterSet.alphanumerics.contains(partialWord.unicodeScalars.first!) else { return [] }
            
            let pattern = "(?:^|\\b|(?<=\\W))" + NSRegularExpression.escapedPattern(for: partialWord) + "\\w+?(?:$|\\b)"
            let regex = try! NSRegularExpression(pattern: pattern)
            
            return regex.matches(in: self.string, range: NSRange(..<self.string.endIndex, in: self.string)).map { (self.string as NSString).substring(with: $0.range) }
        }()
        wordList.append(contentsOf: documentWords)

        // Add words defined in lexer
        if let autocompleteWords = self.autocompleteWords {
            
            let syntaxWords = autocompleteWords.filter { $0.range(of: partialWord, options: [.caseInsensitive, .anchored]) != nil && $0.count != partialWord.count }
            
            wordList.append(contentsOf: syntaxWords)
        }
        
        // Remove double words
        let set:Set<String> = Set(wordList)
        
        return Array(set)
        
    }
}
