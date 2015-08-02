//
//  CustomAnnotationView.swift
//  Around
//
//  Created by Matt on 8/1/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
  override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    let hitView: UIView? = super.hitTest(point, withEvent: event)
    if hitView != nil {
      self.superview?.bringSubviewToFront(self)
    }
    return hitView
  }
  
  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    let time: NSDate = NSDate()
    let rect: CGRect = self.bounds
    var isInside: Bool = CGRectContainsPoint(rect, point)
    if !isInside {
      for view in self.subviews {
        isInside = CGRectContainsPoint(view.frame, point)
        if isInside {
          break
        }
      }
    }
    println("Time: \(time.timeIntervalSinceNow)")
    return isInside
  }
}
