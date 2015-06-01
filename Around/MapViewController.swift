//
//  MapViewController.swift
//  Around
//
//  Created by Matt on 5/31/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var appDelegate:AppDelegate = AppDelegate()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation Bar Setup
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "StreamIcon"), style: .Done, target:self, action: "leftButtonPushed")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Profile"), style: .Done, target:self, action: "rightButtonPushed")
        //self.navigationController?.navigationBar.titleTextAttributes = View.TitleText
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(imageNavBarBackground(), forBarMetrics: .Default)
        self.navigationItem.title = View.AppLabel
        self.navigationController?.navigationBar.barTintColor = View.AppColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // MARK: Configure the map
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftButtonPushed() {
        
    }
    
    func rightButtonPushed() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
