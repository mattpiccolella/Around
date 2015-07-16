//
//  ViewUtils.swift
//  Around
//
//  Created by Matt on 6/1/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation
import UIKit
import MapKit


func imageNavBarBackground() -> UIImage {
    let color: UIColor = View.AppColor
    let rect:CGRect = CGRectMake(0,0,1,1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIRectFill(rect)
    
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
  let point: MKMapPoint = MKMapPoint(x: x, y: y)
  return MKCoordinateForMapPoint(point)
}

func northWestCoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D {
  return getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mapRect), mapRect.origin.y);
}

func southEastCoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D {
  return getCoordinateFromMapRectanglePoint(mapRect.origin.x, MKMapRectGetMaxY(mapRect))
}