//
//  AppDelegate.swift
//  Around
//
//  Created by Matt on 5/31/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
  // Application-wide information
  var searchRadius: Double = 0.0
  var currentUser: PFUser?
  var location: CLLocation?
  var shouldRefreshStreamItems: Bool = false
  var minPoint: CLLocationCoordinate2D?
  var maxPoint: CLLocationCoordinate2D?
  
  
  var streamItemArray: Array<PFObject> = []
  var selectedCategories: [StreamItemType] = []
  var selectedStreamItems: Array<PFObject> = []
  
  var mapViewController: MapViewController!
  var streamViewController: StreamViewController!
  
  var onboardingManager: OnboardingManager?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // MARK: Parse configuration
    Parse.setApplicationId(ParseInfo.appID, clientKey: ParseInfo.clientKey)
    PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
    // MARK: UI configuration
    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    
    mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
    streamViewController = StreamViewController(nibName: "StreamViewController", bundle: nil)
        
    let rootViewController: UIViewController
    // MARK: Check for login credentials
    if (self.isLoggedIn()) {
      rootViewController = loggedInView()
    } else {
      // TODO: Switch this.
      rootViewController = loggedOutView()
    }
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    if let window = window {
      self.window!.rootViewController = rootViewController
      self.window!.makeKeyAndVisible()
    }
    return true
  }
    
  func loggedInView() -> UIViewController {
    let mapViewController: MapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
    let navController: UINavigationController = UINavigationController(rootViewController: mapViewController)
    return navController
  }
    
  func loggedOutView() -> UIViewController {
    var onboarded = NSUserDefaults.standardUserDefaults().boolForKey(hasOnboarded)
    let type: WelcomeViewType = onboarded ? .Onboarded : .First
    let welcomeViewController: WelcomeViewController = WelcomeViewController(nibName: "WelcomeViewController", type: type)
    let navController: UINavigationController = UINavigationController(rootViewController: welcomeViewController)
    return navController
  }
    
  func isLoggedIn() -> Bool {
    if let currentUser = PFUser.currentUser() {
      self.currentUser = currentUser
      return true
    } else {
      return false
    }
  }
}

