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
    /*
    override func didChangeText() {
        super.didChangeText()
        complete(nil)
    }
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        
        super.insertText(string, replacementRange: replacementRange)
        complete(nil)
    }
    
    override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
        
        super.completions(forPartialWordRange: charRange, indexOfSelectedItem: index)
        return ["Hello"]
    }
    
    override func insertCompletion(_ word: String, forPartialWordRange charRange: NSRange, movement: Int, isFinal flag: Bool) {
        print("insert completion")
        
        super.insertCompletion("Hello", forPartialWordRange: charRange, movement: movement, isFinal: flag)
    }*/
	
}
