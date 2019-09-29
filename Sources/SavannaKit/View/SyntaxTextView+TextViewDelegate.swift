//
//  SyntaxTextView+TextViewDelegate.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 17/02/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import Foundation
import AppKit


extension SyntaxTextView: InnerTextViewDelegate {
	
	func didUpdateCursorFloatingState() {
		
		selectionDidChange()
		
	}
    func shouldAutocomplete() -> Bool {
        return allowsAutocomplete
    }
	
}

extension SyntaxTextView {

	func isEditorPlaceholderSelected(selectedRange: NSRange, tokenRange: NSRange) -> Bool {
		
		var intersectionRange = tokenRange
		intersectionRange.location += 1
		intersectionRange.length -= 1
		
		return selectedRange.intersection(intersectionRange) != nil
	}
	
	func updateSelectedRange(_ range: NSRange) {
		textView.selectedRange = range
		self.textView.scrollRangeToVisible(range)		
		self.delegate?.didChangeSelectedRange(self, selectedRange: range)
	}
	
	func selectionDidChange() {
		
		guard let delegate = delegate else {
			return
		}
		
		if let cachedTokens = cachedTokens {
						
            updateEditorPlaceholders(cachedTokens: cachedTokens)
		}
		
		colorTextView(lexerForSource: { (source) -> Lexer in
			return delegate.lexerForSource(source)
		})
		
		previousSelectedRange = textView.selectedRange
		
	}
	
	func updateEditorPlaceholders(cachedTokens: [CachedToken]) {
		
		for cachedToken in cachedTokens {
			
			let range = cachedToken.nsRange
			
			if cachedToken.token.isEditorPlaceholder {
				
				var forceInsideEditorPlaceholder = true
				
				let currentSelectedRange = textView.selectedRange
				
				if let previousSelectedRange = previousSelectedRange {
					
					if isEditorPlaceholderSelected(selectedRange: currentSelectedRange, tokenRange: range) {
						
						// Going right.
						if previousSelectedRange.location + 1 == currentSelectedRange.location {
							
							if isEditorPlaceholderSelected(selectedRange: previousSelectedRange, tokenRange: range) {
								updateSelectedRange(NSRange(location: range.location+range.length, length: 0))
							} else {
								updateSelectedRange(NSRange(location: range.location + 1, length: 0))
							}
							
							forceInsideEditorPlaceholder = false
							break
						}
						
						// Going left.
						if previousSelectedRange.location - 1 == currentSelectedRange.location {
							
							if isEditorPlaceholderSelected(selectedRange: previousSelectedRange, tokenRange: range) {
								updateSelectedRange(NSRange(location: range.location, length: 0))
							} else {
								updateSelectedRange(NSRange(location: range.location + 1, length: 0))
							}
							
							forceInsideEditorPlaceholder = false
							break
						}
						
					}
					
				}
				
				if forceInsideEditorPlaceholder {
					if isEditorPlaceholderSelected(selectedRange: currentSelectedRange, tokenRange: range) {
						
						if currentSelectedRange.location <= range.location || currentSelectedRange.upperBound >= range.upperBound {
							// Editor placeholder is part of larger selected text,
							// so don't change selection.
							break
						}
						
						updateSelectedRange(NSRange(location: range.location+1, length: 0))
						break
					}
				}
				
			}
			
		}
		
	}
	
}
	
extension SyntaxTextView: NSTextViewDelegate {
    
    open func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        guard replacementString == "\n" else {
            return true
        }
            
        let nsText = textView.text as NSString
        
        var currentLine = nsText.substring(with: nsText.lineRange(for: textView.selectedRange))
        
        if currentLine.hasSuffix("\n") {
            currentLine.removeLast()
        }
        
        var newLinePrefix = ""
        
        for char in currentLine {
            
            let tempSet = CharacterSet(charactersIn: "\(char)")
            
            if tempSet.isSubset(of: .whitespacesAndNewlines) {
                newLinePrefix += "\(char)"
            } else {
                break
            }

        }
        
        if !newLinePrefix.isEmpty {
            textView.textStorage?.beginEditing()
            
            if textView.shouldChangeText(in:affectedCharRange, replacementString: newLinePrefix) {
               textView.replaceCharacters(in: affectedCharRange, with: newLinePrefix)
            }

            textView.textStorage?.endEditing()

        }
        
        return true
    }
    
    open func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView, textView == self.textView else {
            return
        }
        
        didUpdateText()
        
    }
    
    func didUpdateText() {
        
        self.invalidateCachedTokens()
        self.textView.invalidateCachedParagraphs()
        
        if let delegate = delegate {
            colorTextView(lexerForSource: { (source) -> Lexer in
                return delegate.lexerForSource(source)
            })
        }
        self.rulerView?.needsDisplay = true
        self.delegate?.didChangeText(self)
    }
    
    open func textViewDidChangeSelection(_ notification: Notification) {
        
        contentDidChangeSelection()

    }
    
}

extension SyntaxTextView {

	func contentDidChangeSelection() {
		
		if ignoreSelectionChange {
			return
		}
		
		ignoreSelectionChange = true
		
		selectionDidChange()
		
		ignoreSelectionChange = false
		
	}
	
}
