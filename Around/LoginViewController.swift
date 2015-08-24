//
//  LoginViewController.swift
//  Around
//
//  Created by Matt on 8/24/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class LoginViewController: BaseViewController {
  
  let defaultBottomSpacing: CGFloat = 215.0
  let annotationReuseIdentifier: String = "reuseId"

  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var emailField: UITextField!
  @IBOutlet var emailLogo: UIButton!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var passwordLogo: UIButton!
  @IBOutlet var forgotPasswordButton: UIButton!
  @IBOutlet var bottomSpacingConstraint: NSLayoutConstraint!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Go", style: .Plain, target: self, action: "performLogin")
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!], forState: UIControlState.Normal)
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!, NSForegroundColorAttributeName: Styles.Colors.GrayLabel], forState: UIControlState.Disabled)
    return rightBarButton
  }
  
  func setupViews() {
    view.backgroundColor = Styles.Colors.LightGray
    bottomSpacingConstraint.constant = defaultBottomSpacing
    formatTopLevelNavBar("LOG IN", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    forgotPasswordButton.setTitleColor(View.AppColor, forState: .Normal)
    forgotPasswordButton.setTitleColor(View.AppColor, forState: .Selected)
    forgotPasswordButton.titleLabel?.font = Styles.Fonts.Title.SemiBold.Small
    setupMapView()
    setupFieldLogos()
    addObservers()
    toggleLogin()
  }
  
  func setupMapView() {
    mapView.userInteractionEnabled = false
    mapView.delegate = self
    let postCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Global.DefaultLat, longitude: Global.DefaultLong)
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postCoord, fromEyeCoordinate: postCoord, eyeAltitude: 1000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(Global.DefaultLat, Global.DefaultLong)
    mapView.addAnnotation(marker)
  }
  
  func setupFieldLogos() {
    emailLogo.layer.cornerRadius = emailLogo.frame.size.width / 2.0
    emailLogo.layer.borderWidth = 1.0
    emailLogo.layer.borderColor = Styles.Colors.GrayLabel.CGColor
    passwordLogo.layer.cornerRadius = passwordLogo.frame.size.width / 2.0
    passwordLogo.layer.borderWidth = 1.0
    passwordLogo.layer.borderColor = Styles.Colors.GrayLabel.CGColor
  }
  
  func addObservers() {
    emailField.addTarget(self, action: "toggleLogin", forControlEvents: .EditingChanged)
    passwordField.addTarget(self, action: "toggleLogin", forControlEvents: .EditingChanged)
  }
  
  func toggleLogin() {
    navigationItem.rightBarButtonItem?.enabled = count(emailField.text) > 0 && count(passwordField.text) > 0
  }
  
  // MARK: Keyboard changes
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomSpacingConstraint.constant = keyboardSize.height + 40.0
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomSpacingConstraint.constant = self.defaultBottomSpacing
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func performLogin() {
    PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) { (currentUser, error) -> Void in
      if currentUser != nil {
        self.appDelegate.window!.rootViewController = self.appDelegate.loggedInView()
      } else {
        println("\(error)")
      }
    }
  }

  @IBAction func forgotPasswordPressed(sender: AnyObject) {
    // TODO: Actually show forgot password screen.
  }
}

extension LoginViewController: MKMapViewDelegate {
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
