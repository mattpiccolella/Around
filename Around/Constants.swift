//
//  Constants.swift
//  Around
//
//  Created by Matt on 5/31/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation
import UIKit

struct View {
    static let AppLabel = "AROUND"
    static let TitleText: Dictionary<String,AnyObject?> = [NSFontAttributeName: UIFont(name: "Avenir", size: 20.0),
        NSForegroundColorAttributeName: UIColor.whiteColor()]
    static let AppColor = UIColor(red: 0.0, green: 204/255.0, blue: 102/255.0, alpha: 0.8)
}

struct ParseInfo {
    static let appID = "p5AXszvVReZoSxb9O6I82VGv9yESwzkO9JZ0I2rA"
    static let clientKey = "cKrKEYY3JngYz3ELhmnbyfL59x6BN8iOgi4pyyKo"
    static let user = "User"
    static let userId = "userId"
}

struct Global {
  static let Delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  static let DefaultLat: CLLocationDegrees = 40.8075
  static let DefaultLong: CLLocationDegrees = -73.9619
}