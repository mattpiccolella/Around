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
    struct Title {
      struct Light {
        static let fontName = "OpenSans-Light"
        static let Medium = UIFont(name: fontName, size: 20.0)
      }
      
      struct Normal {
        static let fontName = "OpenSans-Regular"
        static let Medium = UIFont(name: fontName, size: 20.0)
        static let Large = UIFont(name: fontName, size: 30.0)
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
    
    struct Body {
      struct Normal {
        static let fontName = "AvenirNext-Regular"
        static let Medium = UIFont(name: fontName, size: 14.0)
        static let Large = UIFont(name: fontName, size: 16.0)
      }
    }
  }
  
  struct Colors {
    static let GrayLabel = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
  }
}
