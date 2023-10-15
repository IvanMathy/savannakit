//
//  InnerTextView+Multiline.swift
//  SavannaKit macOS
//
//  Created by Ivan Mathy on 10/14/23.
//  Copyright © 2023 Silver Fox. All rights reserved.
//

import Foundation
import AppKit

extension InnerTextView {
  override func mouseDown(with event: NSEvent) {
    // hijack mouse down
    
    let point = self.convert(event.locationInWindow, from: nil)
    
    guard let textManager = textLayoutManager else {
      return
    }
    
    let anchors = textManager.textSelections
    
    textManager.textSelections = textManager.textSelectionNavigation.textSelections(interactingAt: point, inContainerAt: textManager.documentRange.location, anchors: [], modifiers: .visual, selecting: false, bounds: textManager.usageBoundsForTextContainer)
  }
  
  // This is mouse moved + left click
  override func mouseDragged(with event: NSEvent) {
    print(event)
    
    // I'd be lying if I didn't say this helped me figure out how to get this madness to work:
    // https://github.com/krzyzanowskim/STTextView/blob/main/Sources/STTextView/STTextView%2BSelect.swift#L407
    
    let point = self.convert(event.locationInWindow, from: nil)
    
    guard let textManager = textLayoutManager else {
      return
    }
    
    let anchors = textManager.textSelections
    
    textManager.textSelections = textManager.textSelectionNavigation.textSelections(interactingAt: point, inContainerAt: textManager.documentRange.location, anchors: anchors, modifiers: .visual, selecting: true, bounds: textManager.usageBoundsForTextContainer)
  }

}
