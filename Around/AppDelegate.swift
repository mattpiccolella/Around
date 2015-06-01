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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // MARK: Parse configuration
        Parse.setApplicationId(ParseInfo.appID, clientKey: ParseInfo.clientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        // MARK: UI configuration
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
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
        navController.navigationBar.barTintColor = View.AppColor
        navController.navigationBar.tintColor = UIColor.whiteColor()
        return navController
    }
    
    func loggedOutView() -> UIViewController {
        let tutorialController: TutorialViewController = TutorialViewController()
        let navController: UINavigationController = UINavigationController(rootViewController: tutorialController)
        return navController
    }
    
    func hasUserCredentials() -> Bool {
        return (currentUserId() != nil)
    }
    
    func currentUserId() -> NSString? {
        return (NSUserDefaults.standardUserDefaults().objectForKey(ParseInfo.userId)) as? NSString
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

