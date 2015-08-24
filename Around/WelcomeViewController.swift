//
//  WelcomeViewController.swift
//  Around
//
//  Created by Matt on 8/23/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

enum WelcomeViewType: String {
  case Onboarded = "Onboarded"
  case First = "First"
}

class WelcomeViewController: UIViewController {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var primaryButton: UIButton!
  @IBOutlet var secondaryButton: UIButton!

  var type: WelcomeViewType!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init(nibName nibNameOrNil: String?, type: WelcomeViewType) {
    self.init(nibName: nibNameOrNil, bundle: nil)
    self.type = type
    setup(type)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    setupNavBar()
  }
  
  func setup(type: WelcomeViewType) {
    view.backgroundColor = Styles.Colors.WelcomeColor
    setupNavBar()
    // TODO: Switch fonts as necessary.
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.text = Strings.AppName.uppercaseString
    descriptionLabel.textColor = UIColor.whiteColor()
    descriptionLabel.text = Strings.WelcomeMessage
    setupButtons(type)
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
  
  
  @IBAction func primaryButtonPressed(sender: AnyObject) {
    if type == .Onboarded {
      // TODO: Present login.
    } else {
      // TODO: Present onboarding.
    }
  }

  @IBAction func secondaryButtonPressed(sender: AnyObject) {
    let registerController = SignupViewController(nibName: "SignupViewController", bundle: nil)
    navigationController?.pushViewController(registerController, animated: true)
  }
}
