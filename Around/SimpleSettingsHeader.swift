//
//  SimpleSettingsHeader.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class SimpleSettingsHeader: UICollectionReusableView {

  @IBOutlet var headerLabel: UILabel!
  
  static let cellHeight: CGFloat = 56.0
  static let reuseIdentifier: String = "simpleSettingsHeader"

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func inflate(text: String) {
    headerLabel.text = text
    headerLabel.font = Styles.Fonts.Body.Medium.Large
    headerLabel.textColor = Styles.Colors.GrayLabel
  }
}
