//
//  OnboardingManager.swift
//  Around
//
//  Created by Matt on 8/24/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation

class OnboardingManager {
  let locationPermission = 2
  let messages: [String] = [Strings.Onboarding.DiscoverEverything, Strings.Onboarding.PostInteresting, Strings.Onboarding.PostInteresting]
  let buttonTitles: [String] = [Strings.Next, Strings.Next, Strings.EnableLocation]
  let images: [UIImage] = [UIImage(named: "OnboardingScreenshot")!, UIImage(named: "OnboardingCategories")!, UIImage(named: "OnboardingCategories")!]
  // TODO: Do coordinates later.
  var index: Int

  init() {
    index = 0
  }
  
  func nextViewController() -> OnboardingViewController? {
    if index >= messages.count {
      return nil
    } else {
      let message = messages[index]
      let buttonTitle = buttonTitles[index]
      let image = images[index]
      // TODO: Change these coordinates to coordinates of interest.
      let lat = Global.DefaultLat
      let long = Global.DefaultLong
      let onboardingController = OnboardingViewController(nibName: "OnboardingViewController", message: message, buttonTitle: buttonTitle, image: image, lat: lat, long: long, shouldRequestLocationPermission: index == locationPermission)
      index++
      return onboardingController
    }
  }
}