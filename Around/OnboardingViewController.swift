//
//  OnboardingViewController.swift
//  Around
//
//  Created by Matt on 8/24/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

let hasOnboarded: String = "hasOnboarded"

class OnboardingViewController: BaseViewController {
  
  let annotationReuseIdentifier = "reuseId"
  let mapOpacity: CGFloat = 0.85

  @IBOutlet var containerView: UIView!
  @IBOutlet var actionButton: UIButton!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var messageLabel: UILabel!
  //@IBOutlet var mapView: MKMapView!
  
  var message: String!
  var buttonTitle: String!
  var image: UIImage!
  var lat: CLLocationDegrees!
  var long: CLLocationDegrees!
  
  var locationManager: CLLocationManager?
  var shouldRequestLocation: Bool = false
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init(nibName nibNameOrNil: String?, message: String, buttonTitle: String, image: UIImage, lat: CLLocationDegrees, long: CLLocationDegrees, shouldRequestLocationPermission: Bool) {
    self.init(nibName: nibNameOrNil, bundle: nil)
    self.message = message
    self.buttonTitle = buttonTitle
    self.image = image
    self.lat = lat
    self.long = long
    shouldRequestLocation = shouldRequestLocationPermission
    setup()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setup() {
    view.backgroundColor = UIColor.clearColor()
    navigationItem.hidesBackButton = true
    containerView.backgroundColor = Styles.Colors.WelcomeColor
    messageLabel.textColor = UIColor.whiteColor()
    messageLabel.text = message
    messageLabel.font = Styles.Fonts.Title.Normal.Medium
    imageView.image = image
    setupNavBar()
    setupBackgroundMapView()
    actionButton.backgroundColor = UIColor.whiteColor()
    actionButton.setTitleColor(View.AppColor, forState: .Normal)
    actionButton.setTitleColor(View.AppColor, forState: .Selected)
    actionButton.titleLabel!.font = Styles.Fonts.Title.Normal.Medium
    actionButton.setTitle(buttonTitle, forState: .Normal)
    actionButton.setTitle(buttonTitle, forState: .Selected)
  }
  
  func setupNavBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.translucent = true
    navigationController?.view.backgroundColor = UIColor.clearColor()
  }
  
  func setupBackgroundMapView() {
    /*
    mapView.userInteractionEnabled = false
    mapView.delegate = self
    let postCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postCoord, fromEyeCoordinate: postCoord, eyeAltitude: 2000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(lat, long)
    mapView.addAnnotation(marker)
    */
  }

  @IBAction func actionButtonPressed(sender: AnyObject) {
    if shouldRequestLocation {
      locationManager = CLLocationManager()
      locationManager!.delegate = self
      locationManager?.requestWhenInUseAuthorization()
    } else {
      presentNextViewController()
    }
  }
  
  func presentNextViewController() {
    if let onboardingController = appDelegate.onboardingManager?.nextViewController() {
      navigationController?.pushViewController(onboardingController, animated: true)
    } else {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: hasOnboarded)
      appDelegate.window!.rootViewController = appDelegate.loggedOutView()
    }
  }
}

extension OnboardingViewController: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status != .NotDetermined {
      presentNextViewController()
    }
  }
}

extension OnboardingViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseIdentifier) {
      pinView.annotation = annotation
      return pinView
    } else {
      let newPinView: CustomAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseIdentifier)
      newPinView.canShowCallout = false
      newPinView.image = UIImage(named: "Marker")
      return newPinView
    }
  }
}
