//
//  UserSettingsViewController.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

@objc
protocol UserSettingsActionDelegate {
  func handleFacebookLink()
  func handleTwitterLink()
  func changeEmail()
  func handleProfileChange()
  func viewPostHistory()
  func changePassword()
  func signOut()
}

class UserSettingsViewController: BaseViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  
  var actionDelegate: UserSettingsActionDelegate!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    actionDelegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupCollectionView() {
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerNib(UINib(nibName: "SimpleSettingsCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: SimpleSettingsCell.reuseIdentifier)
    collectionView.registerNib(UINib(nibName: "SimpleSettingsHeader", bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SimpleSettingsHeader.reuseIdentifier)
  }
  
  class func formatCellForIndex(indexPath: NSIndexPath, cell: SimpleSettingsCell) {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        cell.inflate(nil, text: PFUser.currentUser()!["name"] as! String, type: .Large)
      case 1:
        cell.inflate(UIImage(named: "Mail")!, text: PFUser.currentUser()!.email!, type: .Small)
      case 2:
        cell.inflate(UIImage(named: "Facebook")!, text: "Add Facebook", type: .Small)
      case 3:
        cell.inflate(UIImage(named: "Twitter")!, text: "Add Twitter", type: .Small)
      case 4:
        cell.inflate("View Post History")
      case 5:
        cell.inflate("Change Password", lastCell: true)
      default:
        break
      }
    case 1:
      switch indexPath.row {
      case 0:
        cell.inflate("Terms of Service")
      case 1:
        cell.inflate("Privacy Policy")
      case 2:
        cell.inflate("Sign out")
        cell.formatForDestructiveAction()
      default:
        break
      }
    default:
      break
    }
  }
  
  class func typeForIndex(indexPath: NSIndexPath) -> SimpleSettingsCellType {
    return indexPath.row == 0 && indexPath.section == 0 ? SimpleSettingsCellType.Large : SimpleSettingsCellType.Small
  }

}

extension UserSettingsViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let settingsCell: SimpleSettingsCell = collectionView.dequeueReusableCellWithReuseIdentifier(SimpleSettingsCell.reuseIdentifier, forIndexPath: indexPath) as! SimpleSettingsCell
    UserSettingsViewController.formatCellForIndex(indexPath, cell: settingsCell)
    return settingsCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return section == 0 ? 6 : 3
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 2
  }
}

extension UserSettingsViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 0:
    switch indexPath.row {
    case 0:
      actionDelegate.handleProfileChange()
    case 1:
      actionDelegate.changeEmail()
    case 2:
      actionDelegate.handleFacebookLink()
    case 3:
      actionDelegate.handleTwitterLink()
    case 4:
      actionDelegate.viewPostHistory()
    case 5:
      actionDelegate.changePassword()
    default:
      break
    }
    case 1:
    switch indexPath.row {
    case 0:
      println("Decide on actual action")
      // TODO: Implement handler for this once we decide what it is.
    case 1:
      println("Decide on actual action")
      // TODO: Implement handler for this once we decide what it is.
    case 2:
      actionDelegate.signOut()
      // TODO: Implement handler for this once we decide what it is.
    default:
      break
    }
    default:
    break
  }
  }

  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView: SimpleSettingsHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: SimpleSettingsHeader.reuseIdentifier, forIndexPath: indexPath) as! SimpleSettingsHeader
      headerView.inflate("SUPPORT")
      return headerView
    }
    return UICollectionReusableView()
  }
}

extension UserSettingsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellHeight: CGFloat = SimpleSettingsCell.heightForCell(UserSettingsViewController.typeForIndex(indexPath))
    return CGSizeMake(self.view.frame.size.width, cellHeight)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return section == 0 ? CGSizeMake(0,0) : CGSizeMake(view.frame.size.width, SimpleSettingsHeader.cellHeight)
  }
}

extension UserSettingsViewController: UserSettingsActionDelegate {
  func handleFacebookLink() {
    // TODO: Implement
    println("Handle Facebook Link - Not Implemented")
  }
  func handleTwitterLink() {
    // TODO: Implement
    println("Handle Twitter Link - Not Implemented")
  }
  func changeEmail() {
    // TODO: Implement
    println("Change Email - Not Implemented")
  }
  func handleProfileChange() {
    // TODO: Implement
    println("Handle Profile Change - Not Implemented")
  }
  func viewPostHistory() {
    // TODO: Implement
    println("View Post History - Not Implemented")
  }
  func changePassword() {
    // TODO: Implement
    println("Change Password - Not Implemented")
  }
  func signOut() {
    PFUser.logOut()
    appDelegate.window!.rootViewController = appDelegate.loggedOutView()
  }
}
