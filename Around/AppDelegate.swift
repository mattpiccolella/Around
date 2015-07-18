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
  var streamItemArray: Array<PFObject> = []
  var currentUser: PFObject?
  var location: CLLocation?
  var shouldRefreshStreamItems: Bool = false
  var minPoint: CLLocationCoordinate2D?
  var maxPoint: CLLocationCoordinate2D?
  
  var mapViewController: MapViewController!
  var streamViewController: StreamViewController!

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
    if (self.hasUserCredentials()) {
      var query: PFQuery = PFQuery(className: ParseInfo.user)
      query.getObjectInBackgroundWithId(self.currentUserId()! as String, block: {
        (object:PFObject?, error: NSError?) -> Void in
        self.currentUser = object
      })
      rootViewController = loggedInView()
    } else {
      // TODO: Switch this.
      rootViewController = loggedInView()
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
    // TODO: Add logged out view controller.
    return UIViewController()
  }
    
  func hasUserCredentials() -> Bool {
    return (currentUserId() != nil)
  }
    
  func currentUserId() -> NSString? {
    return (NSUserDefaults.standardUserDefaults().objectForKey(ParseInfo.userId)) as? NSString
  }
}

