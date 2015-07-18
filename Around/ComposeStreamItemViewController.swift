//
//  ComposeStreamItemViewController.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class ComposeStreamItemViewController: BaseViewController {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var textView: UITextView!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!

  @IBOutlet var addPhotoView: UIView!
  @IBOutlet var timeRemainingView: UIView!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    formatTopLevelNavBar("NEW SIGHTING", leftBarButton: leftBarButtonItem())
    view.layoutIfNeeded()
    setupGestureRecognizers()
  }
  
  override func viewDidAppear(animated: Bool) {
    textView.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupGestureRecognizers() {
    let addPhotoRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showAddPhotoView")
    addPhotoView.addGestureRecognizer(addPhotoRecognizer)
    
    let timeRemainingRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showTimeRemainingView")
    timeRemainingView.addGestureRecognizer(timeRemainingRecognizer)
  }
  
  func showAddPhotoView() {
    println("Here")
  }
  
  func showTimeRemainingView() {
    println("There")
  }
  
  // MARK: Keyboard changes
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomConstraint.constant = keyboardSize.height
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.bottomConstraint.constant = keyboardSize.height
        self.view.layoutIfNeeded()
      })
    }
  }
}
