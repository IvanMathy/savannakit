//
//  File.swift
//  
//
//  Created by Ivan Mathy on 8/22/22.
//

import Foundation

extension InnerTextView {
    
    func replaceRanges(with replacementClosure: (NSRange) -> NSRange) -> Bool {
        guard let insertionRanges = self.insertionRanges else {
            return false
        }
        
        self.insertionRanges = insertionRanges.map(replacementClosure)
        
        return true;
    }
    
    
//    override func moveWordForward(_ sender: Any?) { // ctrl + option + f
//        print("move word forward")
//    }
//
//    override func moveWordBackward(_ sender: Any?) { // ctrl + option + b
//        print("move word backwards")
//    }
    
    public override func moveToBeginningOfLine(_ sender: Any?) {
        guard self.insertionRanges != nil else {
            return super.moveToBeginningOfLine(sender)
        }
        
        replaceRanges { range in
            
            let newRange = self.getLineRange(for: range.lowerBound)
            
            return NSRange(location: newRange.lowerBound, length: 0)
        }
        
    }
    
    public override func moveToEndOfLine(_ sender: Any?) {
        guard self.insertionRanges != nil else {
            return super.moveToBeginningOfLine(sender)
        }
        
        replaceRanges {
            range in
            
            let newRange = self.getLineRange(for: range.upperBound)
            
            guard range.upperBound != self.text.count else {
                return NSRange(location: range.upperBound, length: 0)
            }
            
            let index = self.text.index(self.text.startIndex, offsetBy: newRange.upperBound - 1)
            
            let newLineOffset = (self.text[index].isNewline) ? 1 : 0
            
            return NSRange(location: newRange.upperBound - newLineOffset, length: 0)
        }
    }
    
    public override func moveToBeginningOfParagraph(_ sender: Any?) {
        print("moveToBeginningOfParagraph")
    }
    
    public override func moveToEndOfParagraph(_ sender: Any?) {
        print("moveToEndOfParagraph")
    }
    
    public override func moveToEndOfDocument(_ sender: Any?) {
        self.insertionRanges = nil;
        super.moveToEndOfDocument(sender)
    }
    
    public override func moveToBeginningOfDocument(_ sender: Any?) {
        self.insertionRanges = nil;
        super.moveToBeginningOfDocument(sender)
    }
    
//    override func pageDown(_ sender: Any?) {
//    }
//
//    override func pageUp(_ sender: Any?) {
//    }
    
//    override func centerSelectionInVisibleArea(_ sender: Any?) {
//    }
    
//    override func moveBackwardAndModifySelection(_ sender: Any?) {
//    }
//
//    override func moveForwardAndModifySelection(_ sender: Any?) {
//    }
    
    public override func moveWordForwardAndModifySelection(_ sender: Any?) {
    }

    public override func moveWordBackwardAndModifySelection(_ sender: Any?) {
    }


    public override func moveToBeginningOfLineAndModifySelection(_ sender: Any?) {
        guard replaceRanges(with: { range in
            let newRange = self.getLineRange(for: range.lowerBound)
            return NSRange(location: newRange.lowerBound, length: range.upperBound - newRange.lowerBound)
        }) else {
            return super.moveToBeginningOfLineAndModifySelection(sender)
        }
    }

    public override func moveToEndOfLineAndModifySelection(_ sender: Any?) {
        guard replaceRanges(with: { range in
            let newRange = self.getLineRange(for: range.upperBound)
            return NSRange(location: range.lowerBound, length: newRange.upperBound - range.lowerBound)
        }) else {
            return super.moveToEndOfLineAndModifySelection(sender)
        }
    }

    public override func moveToBeginningOfParagraphAndModifySelection(_ sender: Any?) {
    }

    public override func moveToEndOfParagraphAndModifySelection(_ sender: Any?) {
    }

    public override func moveToEndOfDocumentAndModifySelection(_ sender: Any?) {
    }

    public override func moveToBeginningOfDocumentAndModifySelection(_ sender: Any?) {
    }

    public override func pageDownAndModifySelection(_ sender: Any?) {
    }

    public override func pageUpAndModifySelection(_ sender: Any?) {
    }

    public override func moveParagraphForwardAndModifySelection(_ sender: Any?) {
    }

    public override func moveParagraphBackwardAndModifySelection(_ sender: Any?) {
        
    }
    
    public override func moveWordRight(_ sender: Any?) {
    }

    public override func moveWordLeft(_ sender: Any?) {
    }

    public override func moveWordRightAndModifySelection(_ sender: Any?) {
    }

    public override func moveWordLeftAndModifySelection(_ sender: Any?) {
    }

    // these call moveToBeginningOfLine and such
//    @available(macOS 10.6, *)
//    override func moveToLeftEndOfLine(_ sender: Any?) {
//        print("moveToLeftEndOfLine")
//    }
//
//    @available(macOS 10.6, *)
//    override func moveToRightEndOfLine(_ sender: Any?) {
//        print("moveToRightEndOfLine")
//    }

//    @available(macOS 10.6, *)
//    override func moveToLeftEndOfLineAndModifySelection(_ sender: Any?) {
//    }
//
//    @available(macOS 10.6, *)
//    override func moveToRightEndOfLineAndModifySelection(_ sender: Any?) {
//    }

    public override func scrollPageUp(_ sender: Any?) {
    }

    public override func scrollPageDown(_ sender: Any?) {
    }

    public override func scrollLineUp(_ sender: Any?) {
    }

    public override func scrollLineDown(_ sender: Any?) {
    }
    
    public override func scrollToBeginningOfDocument(_ sender: Any?) {
    }

    public override func scrollToEndOfDocument(_ sender: Any?) {
    }

    // Graphical Element transposition
    public override func transpose(_ sender: Any?) { // ctrl + t
    }

    public override func transposeWords(_ sender: Any?) {
    }

    public override func selectParagraph(_ sender: Any?) {
    }

    public override func selectLine(_ sender: Any?) {
    }

    public override func selectWord(_ sender: Any?) {
        super.selectWord(sender);
        // https://developer.apple.com/documentation/appkit/nstextview/1449188-selectionrange
    }

    // Insertions and Indentations
    public override func indent(_ sender: Any?) {
    }

//    override func insertNewline(_ sender: Any?) {
//    }

    public override func insertParagraphSeparator(_ sender: Any?) {
    }

    public override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {
    }

    public override func insertTabIgnoringFieldEditor(_ sender: Any?) {
    }

    public override func insertLineBreak(_ sender: Any?) {
    }
    
    public override func insertContainerBreak(_ sender: Any?) {
    }

    @available(macOS 10.5, *)
    public override func insertSingleQuoteIgnoringSubstitution(_ sender: Any?) {
    }

    @available(macOS 10.5, *)
    public override func insertDoubleQuoteIgnoringSubstitution(_ sender: Any?) {
    }

    // Case changes
    public override func changeCaseOfLetter(_ sender: Any?) {
    }

    public override func uppercaseWord(_ sender: Any?) {
    }

    public override func lowercaseWord(_ sender: Any?) {
    }

    public override func capitalizeWord(_ sender: Any?) {
    }

    // Deletions


    public override func deleteBackwardByDecomposingPreviousCharacter(_ sender: Any?) {
    }

    public override func deleteWordForward(_ sender: Any?) { // option + shift + delete
    }

    public override func deleteWordBackward(_ sender: Any?) { // option + delete
    }

    public override func deleteToBeginningOfLine(_ sender: Any?) {
    }

    public override func deleteToEndOfLine(_ sender: Any?) {
    }

    public override func deleteToBeginningOfParagraph(_ sender: Any?) {
    }
}

