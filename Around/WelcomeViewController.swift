//
//  WelcomeViewController.swift
//  Around
//
//  Created by Matt on 8/23/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

enum WelcomeViewType: String {
  case Onboarded = "Onboarded"
  case First = "First"
}

class WelcomeViewController: BaseViewController {
  
  let mapOpacity: CGFloat = 0.85
  let annotationReuseIdentifier = "reuseId"
  
  @IBOutlet var containerView: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var primaryButton: UIButton!
  @IBOutlet var secondaryButton: UIButton!
  @IBOutlet var mapView: MKMapView!

  var type: WelcomeViewType!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init(nibName nibNameOrNil: String?, type: WelcomeViewType) {
    self.init(nibName: nibNameOrNil, bundle: nil)
    self.type = type
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup(type)
  }
  
  override func viewWillAppear(animated: Bool) {
    setupNavBar()
  }
  
  func setup(type: WelcomeViewType) {
    setupNavBar()
    // TODO: Switch fonts as necessary.
    containerView.backgroundColor = Styles.Colors.WelcomeColor.colorWithAlphaComponent(mapOpacity)
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.text = Strings.AppName.uppercaseString
    descriptionLabel.textColor = UIColor.whiteColor()
    descriptionLabel.text = Strings.WelcomeMessage
    setupButtons(type)
    setupBackgroundMapView()
  }
  
  func setupButtons(type: WelcomeViewType) {
    primaryButton.backgroundColor = UIColor.whiteColor()
    secondaryButton.backgroundColor = UIColor.whiteColor()
    primaryButton.setTitleColor(View.AppColor, forState: .Normal)
    primaryButton.setTitleColor(View.AppColor, forState: .Selected)
    secondaryButton.setTitleColor(View.AppColor, forState: .Normal)
    secondaryButton.setTitleColor(View.AppColor, forState: .Normal)
    primaryButton.titleLabel!.font = Styles.Fonts.Title.Normal.Medium
    secondaryButton.titleLabel!.font = Styles.Fonts.Title.Normal.Medium
    
    if type == .Onboarded {
      primaryButton.setTitle(Strings.Login, forState: .Normal)
      primaryButton.setTitle(Strings.Login, forState: .Selected)
      secondaryButton.setTitle(Strings.Register, forState: .Normal)
      secondaryButton.setTitle(Strings.Register, forState: .Selected)
    } else {
      primaryButton.setTitle(Strings.GetStarted, forState: .Normal)
      primaryButton.setTitle(Strings.GetStarted, forState: .Selected)
      secondaryButton.hidden = true
    }
  }
  
  func setupNavBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.translucent = true
    navigationController?.view.backgroundColor = UIColor.clearColor()
  }
  
  func setupBackgroundMapView() {
    mapView.userInteractionEnabled = false
    mapView.delegate = self
    let postCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Global.DefaultLat, longitude: Global.DefaultLong)
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postCoord, fromEyeCoordinate: postCoord, eyeAltitude: 2000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(Global.DefaultLat, Global.DefaultLong)
    mapView.addAnnotation(marker)
  }
  
  
  @IBAction func primaryButtonPressed(sender: AnyObject) {
    if type == .Onboarded {
      let loginController = LoginViewController(nibName: "LoginViewController", bundle: nil)
      navigationController?.pushViewController(loginController, animated: true)
    } else {
      appDelegate.onboardingManager = OnboardingManager()
      let onboardingController = appDelegate.onboardingManager!.nextViewController()
      navigationController?.pushViewController(onboardingController!, animated: true)
    }
  }

  @IBAction func secondaryButtonPressed(sender: AnyObject) {
    let registerController = SignupViewController(nibName: "SignupViewController", bundle: nil)
    navigationController?.pushViewController(registerController, animated: true)
  }
}

extension WelcomeViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
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
