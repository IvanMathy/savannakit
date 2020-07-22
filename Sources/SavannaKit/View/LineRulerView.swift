//
//  LineRulerView.swift
//  SavannaKit macOS
//
//  Created by Ivan on 9/7/19.
//  Copyright © 2019 Silver Fox. All rights reserved.
//

import Foundation
import AppKit

class LineRulerView: NSRulerView {
    
    
    var textView: InnerTextView?
    
    init(textView: InnerTextView) {
        self.textView = textView
        super.init(scrollView: textView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
      
        self.clientView = textView
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = textView, let theme = textView.theme else {
            return
        }
        
        theme.gutterStyle.backgroundColor.setFill()
        
        guard
            theme.lineNumbersStyle != nil
            else {
                let path = BezierPath(rect: rect)
                path.fill()
                return
        }
        
        
        let contentHeight = textView.enclosingScrollView!.documentView!.bounds.height
        
        let yOffset = self.bounds.height - contentHeight
        
        var paragraphs: [Paragraph]
        
        if let cached = textView.cachedParagraphs {
            
            paragraphs = cached
            
        } else {
            
            paragraphs = generateParagraphs(for: textView, flipRects: false)
            textView.cachedParagraphs = paragraphs
            
        }
        
        paragraphs = offsetParagraphs(paragraphs, for: textView, yOffset: yOffset)
        
        let components = textView.text.components(separatedBy: .newlines)
        
        let count = components.count
        
        let maxNumberOfDigits = "\(count)".count
        
        let leftInset: CGFloat = 10.0
        let rightInset: CGFloat = 8.0
        
        let charWidth: CGFloat = 10.0
        
        // Stretch to fit the largest number
        self.ruleThickness = max(theme.gutterStyle.minimumWidth , CGFloat(maxNumberOfDigits) * charWidth + leftInset + rightInset)
        
   
        theme.gutterStyle.backgroundColor.setFill()
    
        let path = BezierPath(rect: rect)
        path.fill()
        
        if let separatorColor = theme.gutterStyle.separatorColor {
            separatorColor.setStroke()
            
            let separator = NSBezierPath()
            separator.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            separator.line(to: CGPoint(x: rect.maxX, y: rect.maxY))
            separator.lineWidth = 2
            separator.stroke()
        }
        
        drawLineNumbers(paragraphs, in: rect, for: textView)
    }
}
