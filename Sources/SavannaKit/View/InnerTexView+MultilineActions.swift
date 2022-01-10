//
//  InnerTexView+MultilineActions.swift
//  SavannaKit macOS
//
//  Created by Ivan on 1/8/22.
//  Copyright © 2022 Silver Fox. All rights reserved.
//

import Foundation

extension InnerTextView {
    // This class overrides default NSTextView actions to support multiline
    
    
    func insert(stringInRanges pairs: [(String, NSRange)]) -> [NSRange]? {
        
        guard
            shouldChangeText(inRanges: pairs.map { NSValue.init(range: $0.1) }, replacementStrings: pairs.map { $0.0 }),
            let textStorage = self.textStorage
        else {
            return nil
        }
        
        textStorage.beginEditing()
        
        var offset = 0
        
        let newPairs = pairs.sorted(by: { $0.1.location < $1.1.location  }).map {
            pair -> NSRange in
            let range = NSRange(location: pair.1.location + offset, length: pair.1.length)
            textStorage.replaceCharacters(in: range, with: pair.0)

            offset += pair.0.count - pair.1.length
            
            return NSRange(location: pair.1.location + offset + pair.1.length, length: 0)
        }
        
        textStorage.endEditing()
        
        self.didChangeText()
        
        return newPairs
    }
    
    // Delete
    
    override func delete(_ sender: Any?) {
        super.delete(sender)
    }
    
    override func deleteForward(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.deleteForward(sender)
        }
        self.moveInsertionPoints(.right)
        self.deleteBackward(sender)
    }
    
    override func deleteBackward(_ sender: Any?) {
        guard let insertionRanges = self.insertionRanges else {
            return super.deleteBackward(sender)
        }
        
        self.insertionRanges = self.insert(stringInRanges: insertionRanges.flatMap({ range in
            guard range.location > 0 else {
                return nil
            }
            return ("", NSRange(location: range.location - 1, length: 1))
        }))
    }
    // Move
    
    override func moveUp(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveUp(sender)
        }
        self.moveInsertionPoints(.up)
    }
    
    override func moveDown(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveDown(sender)
        }
        self.moveInsertionPoints(.down)
    }
    
    override func moveLeft(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveLeft(sender)
        }
        self.moveInsertionPoints(.left)
    }
    override func moveRight(_ sender: Any?) {
        guard (self.insertionRanges != nil) else {
            return super.moveRight(sender)
        }
        self.moveInsertionPoints(.right)
    }
    
    override func moveForward(_ sender: Any?) {
        super.moveForward(sender)
        
        
        // Todo: handle both writing directions? not sure when this function is used.
    }
    
    // Select
    
    override func selectWord(_ sender: Any?) {
        super.selectWord(sender)
        
        // https://developer.apple.com/documentation/appkit/nstextview/1449188-selectionrange
        
    }
    
    override func moveUpAndModifySelection(_ sender: Any?) {
        super.moveUpAndModifySelection(sender)
    }
    
    override func transpose(_ sender: Any?) {
        super.transpose(sender) // ctrl + t
    }
}
