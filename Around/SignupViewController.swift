//
//  SignupViewController.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

enum ActionMode: String {
  case SignUp = "Sign Up"
  case LogIn = "Log In"
}

class SignupViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let confirmPasswordTopMargin: CGFloat = 16.0
  let confirmPasswordBottomMargin: CGFloat = 16.0
  let bottomKeyboardSpacing: CGFloat = 8.0
  
  var profilePicture: PFFile?

  @IBOutlet var emailAddress: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var confirmPassword: UITextField!
  @IBOutlet var primaryAction: UIButton!
  @IBOutlet var secondaryAction: UIButton!
  @IBOutlet var confirmPasswordTopSpacing: NSLayoutConstraint!
  @IBOutlet var confirmPasswordBottomSpacing: NSLayoutConstraint!
  @IBOutlet var secondaryActionBottomSpacing: NSLayoutConstraint!

  @IBOutlet var profilePictureButton: UIButton!
  var action: ActionMode = .SignUp

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewDidAppear(animated: Bool) {
    emailAddress.becomeFirstResponder()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func setupViews() {
    
    toggleSignup()
    addObservers()
    setUIForActions(action)
  }
  
  func addObservers() {
    emailAddress.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
    password.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
    confirmPassword.addTarget(self, action: "toggleSignup", forControlEvents: .EditingChanged)
  }
  
  func toggleSignup() {
    var canSignUp: Bool
    if action == .SignUp {
      canSignUp = count(emailAddress.text) > 0 && count(password.text) > 0 && count(confirmPassword.text) > 0 && password.text == confirmPassword.text && profilePicture != nil
    } else {
      canSignUp = count(emailAddress.text) > 0 && count(password.text) > 0
    }
    primaryAction.enabled = canSignUp
  }
  
  @IBAction func performPrimaryAction(sender: AnyObject) {
    if action == .SignUp {
      performSignup()
    } else {
      performLogin()
    }
  }

  @IBAction func performSecondaryAction(sender: AnyObject) {
    let newAction = action == ActionMode.SignUp ? ActionMode.LogIn : ActionMode.SignUp
    action = newAction
    setUIForActions(newAction)
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

  func setUIForActions(actionType: ActionMode) {
    if actionType == .SignUp {
      UIView.animateWithDuration(0.1, animations: {
        self.confirmPassword.hidden = false
        self.confirmPasswordTopSpacing.constant = self.confirmPasswordTopMargin
        self.confirmPasswordBottomSpacing.constant = self.confirmPasswordBottomMargin
        self.primaryAction.setTitle("Sign Up", forState: .Normal)
        self.primaryAction.setTitle("Sign Up", forState: .Disabled)
        self.secondaryAction.setTitle("Log In", forState: .Normal)
        self.secondaryAction.setTitle("Log In", forState: .Selected)
        self.profilePictureButton.hidden = false
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animateWithDuration(0.1, animations: {
        self.confirmPassword.hidden = true
        self.confirmPasswordTopSpacing.constant = 0
        self.confirmPasswordBottomSpacing.constant = 0
        self.primaryAction.setTitle("Log In", forState: .Normal)
        self.primaryAction.setTitle("Log In", forState: .Disabled)
        self.secondaryAction.setTitle("Sign Up", forState: .Normal)
        self.secondaryAction.setTitle("Sign Up", forState: .Selected)
        self.profilePictureButton.hidden = true
        self.view.layoutIfNeeded()
      })
    }
  }
  
  func performSignup() {
    let newUser: PFUser = PFUser()
    newUser.username = emailAddress.text
    newUser.password = password.text
    newUser.email = emailAddress.text
    newUser["profilePicture"] = profilePicture!
    newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
      if success {
        self.appDelegate.window!.rootViewController = self.appDelegate.loggedInView()
      } else {
        println("\(error)")
      }
    }
  }
  
  func performLogin() {
    PFUser.logInWithUsernameInBackground(emailAddress.text, password: password.text) { (currentUser, error) -> Void in
      if currentUser != nil {
        self.appDelegate.window!.rootViewController = self.appDelegate.loggedInView()
      } else {
        println("\(error)")
      }
    }
  }
  
  // MARK: Keyboard changes
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      self.secondaryActionBottomSpacing.constant = keyboardSize.height + bottomKeyboardSpacing
      self.view.layoutIfNeeded()
    }
  }
}

extension SignupViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    let imageData = UIImageJPEGRepresentation(image, 0.7)
    profilePicture = PFFile(data: imageData)
    profilePictureButton.setImage(image, forState: .Normal)
    profilePictureButton.setImage(image, forState: .Selected)
    dismissViewControllerAnimated(true, completion: nil)
    toggleSignup()
  }
}
