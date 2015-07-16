//
//  MapViewController.swift
//  Around
//
//  Created by Matt on 5/31/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    
  @IBOutlet var mapView: MKMapView!
  
  private var hasLoadedInitialMarkers: Bool = false
  var postSelected: Bool = false
  
  var locationManager: CLLocationManager = CLLocationManager()

    
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    formatTopLevelNavBar("FILTER", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    if appDelegate.shouldRefreshStreamItems {
      fetchNewStreamItems() {
        self.addMapMarkers()
      }
      appDelegate.shouldRefreshStreamItems = false
    } else if !postSelected {
      addMapMarkers()
    } else {
      postSelected = false;
    }
    
    // TODO: Look into consistency and other things.
  }
  
  override func viewDidAppear(animated: Bool) {
    checkLocationAuthorizationStatus()
  }
  
  func addMapMarkers() {
    for item in appDelegate.streamItemArray {
      let marker: MKPointAnnotation = MKPointAnnotation()
      marker.coordinate = CLLocationCoordinate2DMake(item["latitude"]!.doubleValue, item["longitude"]!.doubleValue)
      mapView.addAnnotation(marker)
    }
  }
  
  func loadInitialStreamItems() {
    // Bad hack. We try to load only based off of whether there are any objects available.
    if count(appDelegate.streamItemArray) == 0 {
      fetchNewStreamItems() {
        self.addMapMarkers()
      }
    } else {
      addMapMarkers()
    }
  }

  
  // MARK: Location services.
  func checkLocationAuthorizationStatus() {
    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
      mapView.showsUserLocation = true
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  // MARK: Navigation bar setup.

  override func leftButtonPushed() {
    // TODO: Go to stream.
  }

  override func leftBarButtonItem() -> UIBarButtonItem {
    let listImage: UIImage = UIImage(named: "Stream")!
    let button: UIButton = barButtonImage(listImage)
    button.addTarget(self, action: "leftButtonPushed", forControlEvents: .TouchUpInside)
    let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: listImage, style: .Done, target: self, action: "leftButtonPushed")
    return leftBarButton
  }

  func rightButtonPushed() {
    // TODO: Go to profile.
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    // TODO: Make this a real profile image.
    let profileImage: UIImage = UIImage(named: "Profile")!
    let button: UIButton = barButtonImage(profileImage)
    button.layer.cornerRadius = barButtonHeight / 2.0
    button.layer.masksToBounds = true
    button.addTarget(self, action: "rightButtonPushed", forControlEvents: .TouchUpInside)
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(customView: button)
    return rightBarButton
  }

  @IBAction func currentLocationButtonPressed(sender: AnyObject) {
    if let coordinate = appDelegate.location?.coordinate {
      mapView.setCenterCoordinate(coordinate, animated: true)
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
    appDelegate.location = newLocation
    if !hasLoadedInitialMarkers {
      hasLoadedInitialMarkers = true
      // TODO: Make eye altitude not constant. Look for a way to do it to ensure markers are present.
      let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: newLocation.coordinate, fromEyeCoordinate: newLocation.coordinate, eyeAltitude: 10000)
      mapView.camera = camera
      appDelegate.minPoint = northWestCoordinate(mapView.visibleMapRect)
      appDelegate.maxPoint = southEastCoordinate(mapView.visibleMapRect)
      loadInitialStreamItems()
    } else {
      
    }
  }
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    // TODO: Check whether we can show some kind of error here.
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    // TODO: Handle error.
  }
}
