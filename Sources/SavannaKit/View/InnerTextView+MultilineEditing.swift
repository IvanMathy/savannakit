//
//  InnerTextView+MultilineEditing.swift
//  SavannaKit macOS
//
//  Created by Ivan on 12/29/21.
//  Copyright © 2021 Silver Fox. All rights reserved.
//

import Foundation
import AppKit

extension InnerTextView {
    
    func characterIndex(for event: NSEvent) -> Int? {
        
        guard
            let layoutManager = layoutManager,
            let textStorage   = textStorage,
            let textContainer = textContainer
        else {
            return nil
        }
        
        let point = self.convert(event.locationInWindow, from: nil)
        var fraction: CGFloat = 0

        var index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: &fraction)

        if (fraction > 0.5 && index < textStorage.length &&
            (textStorage.string as NSString).character(at: index) != 0)
        {
          index += 1;
        }

        return index
    }
    
    override func mouseDown(with event: NSEvent) {
        guard event.modifierFlags.contains(.option) else {
            self.setNeedsDisplay(NSRect.zero, avoidAdditionalLayout: true)
            insertionPoints = nil
            return super.mouseDown(with: event)
        }
        
        startIndex = characterIndex(for: event)
        insertionPoints = [1, 10, 15]
    }
    
    override func mouseDragged(with event: NSEvent) {
        let index = characterIndex(for: event)!
        let glyphIndex = layoutManager?.glyphIndexForCharacter(at: index)
        
        (string as NSString).lineRange(for: <#T##NSRange#>)
        
        layoutManager?.enumerateLineFragments(forGlyphRange: <#T##NSRange#>, using: <#T##(NSRect, NSRect, NSTextContainer, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void#>)
        
        print(layoutManager!.truncatedGlyphRange(inLineFragmentForGlyphAt: glyphIndex!))
    }
    
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        guard let insertionPoints = insertionPoints else {
            return super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
        }
        
        for point in insertionPoints {
            var rect = layoutManager!.boundingRect(forGlyphRange: NSRange(location: point, length: 1), in: textContainer!)
            rect = NSRect(origin: rect.origin, size: NSSize(width: 1, height: rect.height))
            super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
            
            
        }
        
        
    }
    
    override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout flag: Bool) {
        super.setNeedsDisplay(rect, avoidAdditionalLayout: flag)
        
        insertionPoints?.forEach({ point in
            let rect = layoutManager!.boundingRect(forGlyphRange: NSRange(location: point, length: 1), in: textContainer!)
            super.setNeedsDisplay(rect, avoidAdditionalLayout: flag)
        })
    }
    
    override func insertText(_ insertString: Any) {
        guard let insertionPoints = insertionPoints else {
            return super.insertText(insertString)
        }
        
        insertionPoints.forEach { point in
            self.setSelectedRange(NSRange(location: point, length: 0))
            super.insertText(insertString)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
        startIndex = nil
    }
}
