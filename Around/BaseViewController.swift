//
//  BaseViewController.swift
//  Around
//
//  Created by Matt on 7/15/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  let barButtonHeight: CGFloat = 30.0
  
  var categoryFilter: CategoryFilterView?
  
  let appDelegate: AppDelegate = Global.Delegate
  
  func formatTopLevelNavBar(title: String, leftBarButton: UIBarButtonItem? = nil, rightBarButton: UIBarButtonItem? = nil, color: UIColor = View.AppColor, isFilter: Bool = false) {
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.navigationBar.setBackgroundImage(imageNavBarBackground(color), forBarMetrics: .Default)
    self.navigationController?.navigationBar.barTintColor = color
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationItem.titleView = isFilter ? filterTitleView(false) : titleView(title)
    if leftBarButton != nil {
      self.navigationItem.leftBarButtonItem = leftBarButton
    }
    if rightBarButton != nil {
      self.navigationItem.rightBarButtonItem = rightBarButton
    }
  }
  
  private func titleView(title: String) -> UIView {
    let label: UILabel = UILabel(frame: CGRectZero)
    label.backgroundColor = UIColor.clearColor()
    label.font = Styles.Fonts.Title.SemiBold.Medium
    label.textAlignment = .Center
    label.textColor = UIColor.whiteColor()
    label.text = title
    label.sizeToFit()
    addFilterGestureRecognizer(label)
    return label
  }
  
  func filterTitleView(isFiltering: Bool) -> UIButton {
    let button: UIButton = UIButton(frame: CGRectZero)
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.setTitle("FILTER", forState: .Normal)
    button.setTitle("FILTER", forState: .Selected)
    button.backgroundColor = UIColor.clearColor()
    button.titleLabel?.font = Styles.Fonts.Title.SemiBold.Medium
    button.titleLabel?.textAlignment = .Center
    button.titleLabel?.sizeToFit()
    button.userInteractionEnabled = true
    let image = isFiltering ? UIImage(named: "UpArrowWhite") : UIImage(named: "DownArrowWhite")
    let scaledImage = scaleImage(image!, 0.7)
    button.setImage(scaledImage, forState: .Normal)
    button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.titleLabel?.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageView?.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
    button.sizeToFit()
    button.addTarget(self, action: "filterCategories", forControlEvents: .TouchUpInside)
    return button
  }
  
  func addFilterGestureRecognizer(label: UILabel) {
    let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "filterCategories")
    label.addGestureRecognizer(tapGestureRecognizer)
    label.userInteractionEnabled = true
  }
  
  func filterCategories() {
    // Do nothing here. Let it be overriden as needed.
  }
  
  func barButtonImage(image: UIImage?) -> UIButton {
    let button: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
    button.frame = CGRectMake(0, 0, barButtonHeight, barButtonHeight)
    if image != nil {
      button.setImage(image, forState: .Normal) 
    }
    return button
  }
  
  func leftButtonPushed() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func leftBarButtonItem() -> UIBarButtonItem {
    let profileImage: UIImage = UIImage(named: "Back")!
    let button: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
    button.frame = CGRectMake(0, 0, barButtonHeight, barButtonHeight)
    button.setImage(profileImage, forState: .Normal)
    button.addTarget(self, action: "leftButtonPushed", forControlEvents: .TouchUpInside)
    let leftBarButton: UIBarButtonItem = UIBarButtonItem(customView: button)
    return leftBarButton
  }
  
  func fetchNewStreamItems(completion: (() -> Void)?) {
    let query: PFQuery = getStreamItems(appDelegate.minPoint!, appDelegate.maxPoint!)
    query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
      self.appDelegate.streamItemArray = results as! Array<PFObject>
      self.filterStreamItems()
      completion?()
      return
    }
  }
  
  func filterStreamItems() {
    appDelegate.selectedStreamItems = []
    if count(appDelegate.selectedCategories) == 0 {
      appDelegate.selectedStreamItems = appDelegate.streamItemArray
    } else {
      for item in appDelegate.streamItemArray {
        if let type: StreamItemType = StreamItemType(rawValue: item["type"] as! String) {
          if let index: Int = find(appDelegate.selectedCategories, type) {
            appDelegate.selectedStreamItems.append(item)
          }
        }
      }
    }
  }
}
