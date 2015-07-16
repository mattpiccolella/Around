//
//  Styles.swift
//  Around
//
//  Created by Matt on 7/15/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation

struct Styles {
  struct Fonts {

    struct Light {
      static let fontName = "OpenSans-Light"
      static let Medium = UIFont(name: fontName, size: 20.0)
    }
  
    struct Normal {
      static let fontName = "OpenSans-Regular"
      static let Medium = UIFont(name: fontName, size: 20.0)
      static let Large = UIFont(name: fontName, size: 40.0)
    }
  
    struct SemiBold {
      static let fontName = "OpenSans-Semibold"
      static let Medium = UIFont(name: fontName, size: 20.0)
    }
  
    struct Bold {
      static let fontName = "OpenSans-Bold"
      static let Medium = UIFont(name: fontName, size: 20.0)
    }
  }
}