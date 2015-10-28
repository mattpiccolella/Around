//
//  SignupViewController.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class SignupViewController: BaseViewController, UINavigationControllerDelegate, UITextFieldDelegate {

  let bottomKeyboardSpacing: CGFloat = 8.0
  let topBottomTermsPadding: CGFloat = 90.0
  
  let annotationReuseIdentifier = "markerId"
  
  var profilePicture: PFFile?

  @IBOutlet var contentView: UIView!
  @IBOutlet var termsLabel: UILabel!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var bottomSpacingConstraint: NSLayoutConstraint!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var emailAddress: UITextField!
  @IBOutlet var name: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var inputFieldView: UIView!
  @IBOutlet var emailLogo: UIButton!
  @IBOutlet var nameLogo: UIButton!
  @IBOutlet var passwordLogo: UIButton!

  @IBOutlet var profilePictureButton: UIButton!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewDidAppear(animated: Bool) {
    //emailAddress.becomeFirstResponder()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func setupViews() {
    contentView.backgroundColor = Styles.Colors.LightGray
    scrollView.backgroundColor = Styles.Colors.LightGray
    termsLabel.text = Strings.PolicyWarning
    termsLabel.font = Styles.Fonts.Body.Normal.Medium
    termsLabel.textColor = Styles.Colors.GrayLabel
    formatTopLevelNavBar("SIGN UP", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    mapView.userInteractionEnabled = false
    mapView.delegate = self
    profilePictureButton.layer.cornerRadius = profilePictureButton.frame.size.width / 2.0
    profilePictureButton.layer.masksToBounds = true
    setupFieldLogos()
    setupMapView()
    toggleSignup()
    addObservers()
  }
  
  func setupFieldLogos() {
    emailLogo.layer.cornerRadius = emailLogo.frame.size.width / 2.0
    emailLogo.layer.borderWidth = 1.0
    emailLogo.layer.borderColor = Styles.Colors.GrayLabel.CGColor
    nameLogo.layer.cornerRadius = nameLogo.frame.size.width / 2.0
    nameLogo.layer.borderWidth = 1.0
    nameLogo.layer.borderColor = Styles.Colors.GrayLabel.CGColor
    passwordLogo.layer.cornerRadius = passwordLogo.frame.size.width / 2.0
    passwordLogo.layer.borderWidth = 1.0
    passwordLogo.layer.borderColor = Styles.Colors.GrayLabel.CGColor
  }
  
  func setupMapView() {
    let postCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Global.DefaultLat, longitude: Global.DefaultLong)
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postCoord, fromEyeCoordinate: postCoord, eyeAltitude: 1000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(Global.DefaultLat, Global.DefaultLong)
    mapView.addAnnotation(marker)
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "performSignup")
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!], forState: UIControlState.Normal)
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!, NSForegroundColorAttributeName: Styles.Colors.GrayLabel], forState: UIControlState.Disabled)
    return rightBarButton
  }
  
  func addObservers() {
    emailAddress.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
    name.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
    password.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
  }
  
  func toggleSignup() {
    navigationItem.rightBarButtonItem?.enabled = emailAddress.text!.characters.count > 0 && password.text!.characters.count > 0 && name.text!.characters.count > 0
  }
  
  @IBAction func performPrimaryAction(sender: AnyObject) {
    let newUser: PFUser = PFUser()
    newUser.username = emailAddress.text
    newUser.password = password.text
    newUser.email = emailAddress.text
    newUser["profilePicture"] = profilePicture!
    newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
      if success {
        self.appDelegate.window!.rootViewController = self.appDelegate.loggedInView()
      } else {
        print("\(error)")
      }
    }
  }
  
  @IBAction func pickProfilePicture(sender: AnyObject) {
    let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
      let imagePicker: UIImagePickerController = UIImagePickerController()
      imagePicker.sourceType = .Camera
      imagePicker.allowsEditing = true
      imagePicker.delegate = self
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) { (action) -> Void in
      let imagePicker: UIImagePickerController = UIImagePickerController()
      imagePicker.sourceType = .PhotoLibrary
      imagePicker.allowsEditing = true
      imagePicker.delegate = self
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      // TODO: Cancel.
    }
    alertController.addAction(takePhotoAction)
    alertController.addAction(photoLibraryAction)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true) { () -> Void in
      // TODO: I guess nothing?
    }
  }
  
  func performSignup() {
    let newUser: PFUser = PFUser()
    newUser.username = emailAddress.text
    newUser.password = password.text
    newUser.email = emailAddress.text
    if profilePicture != nil {
      newUser["profilePicture"] = profilePicture!
    }
    newUser["name"] = name.text
    newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
      if success {
        self.appDelegate.window!.rootViewController = self.appDelegate.loggedInView()
      } else {
        print("\(error)")
      }
    }
  }

  // MARK: Keyboard changes
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomSpacingConstraint.constant = keyboardSize.height
        let newContentHeight = self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.termsLabel.frame.size.height + self.topBottomTermsPadding + 20.0
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x, newContentHeight), animated: false)
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomSpacingConstraint.constant = 0
        self.view.layoutIfNeeded()
      })
    }
  }
}

extension SignupViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    let imageData = UIImageJPEGRepresentation(image, 0.7)
    profilePicture = PFFile(data: imageData!)
    profilePictureButton.setBackgroundImage(image, forState: .Normal)
    profilePictureButton.setBackgroundImage(image, forState: .Selected)
    // TODO: Figure out why the image isn't a circle here.
    dismissViewControllerAnimated(true, completion: nil)
    toggleSignup()
  }
}

extension SignupViewController: MKMapViewDelegate {
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
