//
//  SelectedCategoryCell.swift
//  Around
//
//  Created by Matt on 8/1/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class SelectedCategoryCell: UICollectionViewCell {
  
  static let reuseIdentifier = "selectedCategoryCell"
  static let cellSize: CGFloat = 20.0
  static let cellPadding: CGFloat = 7.5

  @IBOutlet var filterImage: UIImageView!
  
  func inflate(type: StreamItemType) {
    filterImage.image = UIImage(named: type.rawValue)
  }

}
