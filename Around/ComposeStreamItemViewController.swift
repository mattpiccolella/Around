//
//  ComposeStreamItemViewController.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

enum StreamItemType: String {
  case Food = "Food"
  case Shopping = "Shopping"
  case Academic = "Academic"
  case Entertainment = "Entertainment"
  case Social = "Social"
  case Other = "Other"
}

class ComposeStreamItemViewController: BaseViewController, UINavigationControllerDelegate {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var textView: UITextView!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!
  @IBOutlet var addPhotoView: UIView!
  @IBOutlet var timeRemainingView: UIView!
  @IBOutlet var addPhotoLabel: UILabel!
  @IBOutlet var timeRemainingLabel: UILabel!
  @IBOutlet var addPhotoIcon: UIImageView!
  
  var photoSelected: Bool = false
  var postPhoto: PFFile? = nil
  var datePickerView: UIDatePicker? = nil
  var isPickingTime: Bool = false
  var timeSelected: NSTimeInterval = 0.0
  var postLocation: CLLocationCoordinate2D!
  
  var type: StreamItemType!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, type: StreamItemType) {
    self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.type = type
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    formatTopLevelNavBar("NEW SIGHTING", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    view.layoutIfNeeded()
    setupGestureRecognizers()
    setupViews()
  }
  
  override func viewDidAppear(animated: Bool) {
    if !isPickingTime {
      textView.becomeFirstResponder()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupViews() {
    textView.font = Styles.Fonts.Body.Normal.Large
    textView.delegate = self
    addPhotoLabel.font = Styles.Fonts.Body.Normal.Medium
    addPhotoLabel.textColor = Styles.Colors.GrayLabel
    timeRemainingLabel.font = Styles.Fonts.Body.Normal.Medium
    timeRemainingLabel.textColor = Styles.Colors.GrayLabel
    navigationItem.rightBarButtonItem?.enabled = false
    setupMapView()
  }
  
  func setupMapView() {
    postLocation = appDelegate.location!.coordinate
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postLocation, fromEyeCoordinate: postLocation, eyeAltitude: 10000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(postLocation!.latitude, postLocation!.longitude)
    mapView.addAnnotation(marker)
    mapView.showsUserLocation = true
    mapView.userInteractionEnabled = false
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addPost")
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!], forState: UIControlState.Normal)
    rightBarButton.setTitleTextAttributes([NSFontAttributeName: Styles.Fonts.Title.SemiBold.Medium!, NSForegroundColorAttributeName: Styles.Colors.GrayLabel], forState: UIControlState.Disabled)
    return rightBarButton
  }
  
  func addPost() {
    let streamItem = PFObject(className: "StreamItem")
    //streamItem.setObject(nil, forKey: "user")
    //streamItem.setObject(nil, forKey: "userId")
    streamItem.setObject(textView.text, forKey: "description")
    streamItem.setObject(NSDate.timeIntervalSinceReferenceDate(), forKey: "postedTimestamp")
    streamItem.setObject(NSDate.timeIntervalSinceReferenceDate() + timeSelected, forKey: "expiredTimestamp")
    streamItem.setObject(postLocation.latitude, forKey: "latitude")
    streamItem.setObject(postLocation.longitude, forKey: "longitude")
    streamItem.setObject(postPhoto!, forKey: "postPicture")
    streamItem.setObject(PFUser.currentUser()!, forKey: "user")
    streamItem.setObject(type.rawValue, forKey: "type")
    streamItem.saveInBackgroundWithBlock { (succeeded, error) -> Void in
      if succeeded {
        println("Woohoo!")
      } else {
        println("Daw :(")
      }
    }
  }
  
  func togglePostButton() {
    navigationItem.rightBarButtonItem?.enabled = count(textView.text) > 0 && photoSelected
  }
  
  // MARK: Subviews
  func setupGestureRecognizers() {
    let addPhotoRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showAddPhotoView")
    addPhotoView.addGestureRecognizer(addPhotoRecognizer)
    
    let timeRemainingRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showTimeRemainingView")
    timeRemainingView.addGestureRecognizer(timeRemainingRecognizer)
  }
  
  func showAddPhotoView() {
    /* TODO: Possibly use this later.
    let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    let takePhoto: UIAlertAction = UIAlertAction(title: "Take a Photo", style: .Default) { (alert) -> Void in
      println("Take a photo")
    }
    let photoLibrary: UIAlertAction = UIAlertAction(title: "Choose from Library", style: .Default) { (alert) -> Void in
      println("Choose from Library")
    }
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
      println("Cancel")
    }
    alertController.addAction(takePhoto)
    alertController.addAction(photoLibrary)
    alertController.addAction(cancelAction)
    */
    if photoSelected {
      // Present remove photo option.
    } else {
      let imagePicker: UIImagePickerController = UIImagePickerController()
      imagePicker.sourceType = .PhotoLibrary
      imagePicker.allowsEditing = true
      imagePicker.delegate = self
      presentViewController(imagePicker, animated: true, completion: nil)
    }
  }
  
  func showTimeRemainingView() {
    isPickingTime = true
    textView.resignFirstResponder()
    let datePickerFrame: CGRect = CGRectMake(0, view.frame.size.height - bottomConstraint.constant, view.frame.size.width, bottomConstraint.constant)
    datePickerView = UIDatePicker(frame: datePickerFrame)
    datePickerView!.datePickerMode = UIDatePickerMode.CountDownTimer
    datePickerView!.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    datePickerView!.minuteInterval = 5
    view.addSubview(datePickerView!)
  }
  
  func datePickerValueChanged(sender: AnyObject) {
    let datePicker: UIDatePicker = sender as! UIDatePicker
    timeRemainingLabel.text = remainingTimeString(Int(datePicker.countDownDuration / 60.0))
    timeSelected = datePicker.countDownDuration
  }
  
  
  // MARK: Keyboard changes
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      if !isPickingTime {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
          self.bottomConstraint.constant = keyboardSize.height
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      if !isPickingTime {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
          self.bottomConstraint.constant = 0
          self.view.layoutIfNeeded()
        })
      }
    }
  }
}

extension ComposeStreamItemViewController: UITextViewDelegate {
  func textViewDidChange(textView: UITextView) {
    togglePostButton()
  }
  
  func textViewDidBeginEditing(textView: UITextView) {
    textView.becomeFirstResponder()
    isPickingTime = false
    datePickerView?.removeFromSuperview()
  }
}

extension ComposeStreamItemViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    let imageData = UIImageJPEGRepresentation(image, 0.7)
    postPhoto = PFFile(data: imageData)
    photoSelected = true
    addPhotoIcon.image = image
    dismissViewControllerAnimated(true, completion: nil)
    addPhotoLabel.text = "Photo added"
    addPhotoLabel.textColor = View.AppColor
    navigationItem.rightBarButtonItem?.enabled = count(textView.text) > 0 && photoSelected
  }
}
