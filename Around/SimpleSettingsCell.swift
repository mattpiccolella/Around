//
//  SimpleSettingsCell.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

let settingsTopRightPadding: CGFloat = 17.0

enum SimpleSettingsCellType: CGFloat {
  case Small = 25.0
  case Large = 50.0
}

class SimpleSettingsCell: UICollectionViewCell {

  @IBOutlet var cellLogo: UIImageView!
  @IBOutlet var cellLabel: UILabel!
  @IBOutlet var imageDimenConstraint: NSLayoutConstraint!
  @IBOutlet var imageLabelPadding: NSLayoutConstraint!
  @IBOutlet var separatorLeftPadding: NSLayoutConstraint!


  var type: SimpleSettingsCellType!

  static let reuseIdentifier = "simpleSettingsCell"

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func inflate(text: String, lastCell: Bool = false) {
    cellLabel.text = text
    cellLabel.font = Styles.Fonts.Body.Normal.Medium
    imageDimenConstraint.constant = 0
    imageLabelPadding.constant = 0
    separatorLeftPadding.constant = lastCell ? 0 : 8.0
    layoutIfNeeded()
  }
  
  func inflate(image: UIImage?, text: String, type: SimpleSettingsCellType, lastCell: Bool = false) {
    self.type = type
    cellLabel.font = Styles.Fonts.Body.Normal.Medium
    cellLogo.layer.cornerRadius = type.rawValue / 2.0
    cellLogo.layer.masksToBounds = true
    cellLogo.contentMode = UIViewContentMode.ScaleAspectFit
    if image != nil {
      cellLogo.image = image
    } else {
      if let picture: PFFile = PFUser.currentUser()!["profilePicture"] as? PFFile {
          picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
            if error == nil {
              let image: UIImage? = UIImage(data: data!)
              self.cellLogo.image = image
            }
        })
      }
    }
    cellLogo.image = image
    cellLabel.text = text
    imageDimenConstraint.constant = type.rawValue
    separatorLeftPadding.constant = lastCell ? 0 : 8.0
    layoutIfNeeded()
  }
  
  class func heightForCell(type: SimpleSettingsCellType) -> CGFloat {
    let height: CGFloat = settingsTopRightPadding + type.rawValue
    return settingsTopRightPadding + type.rawValue
  }
  
  func formatForDestructiveAction() {
    cellLabel.font = Styles.Fonts.Body.Medium.Medium
    cellLabel.textColor = UIColor.redColor()
  }

}
