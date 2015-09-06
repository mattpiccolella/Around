//
//  TriangleView.swift
//  Around
//
//  Created by Matt on 9/6/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import Foundation

class TriangleView : UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect) {
    var context: CGContextRef = UIGraphicsGetCurrentContext()
    
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
    CGContextAddLineToPoint(context, (CGRectGetMaxX(rect)/2.0), CGRectGetMaxY(rect))
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
    CGContextClosePath(context)
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
    CGContextSetStrokeColorWithColor(context, Styles.Colors.MarkerBorder.CGColor)
    CGContextDrawPath(context, kCGPathFillStroke)
  }
}
