//
//  Utils.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation

func stringForRemainingTime(numberOfMinutes: Int) -> String {
  if numberOfMinutes < 0 {
    return "0m"
  } else if numberOfMinutes < 60 {
    return "\(numberOfMinutes)m"
  } else {
    return "\(numberOfMinutes / 60)h"
  }
}