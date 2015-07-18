//
//  StreamItemCell.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

let topBottomPadding: CGFloat = 48.0
let userPhotoHeight: CGFloat = 30.0
let leftRightPadding: CGFloat = 32.0

class StreamItemCell: UICollectionViewCell {
  
  static let reuseIdentifier = "streamItemCell"

  @IBOutlet var postDescription: UILabel!
  @IBOutlet var userPhoto: UIImageView!
  @IBOutlet var userName: UILabel!
  @IBOutlet var timeRemaining: UILabel!
  @IBOutlet var distanceLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    postDescription.font = Styles.Fonts.Body.Normal.Large
    postDescription.lineBreakMode = NSLineBreakMode.ByWordWrapping
    userName.font = Styles.Fonts.Body.Normal.Medium
    timeRemaining.font = Styles.Fonts.Body.Normal.Medium
    distanceLabel.font = Styles.Fonts.Body.Normal.Medium
  }
  
  func inflate(streamItem: PFObject) {
    postDescription.text = streamItem["description"] as? String
    let expirationDate: NSDate = NSDate(timeIntervalSinceReferenceDate: streamItem["expiredTimestamp"]!.doubleValue!)
    let timeInterval: NSTimeInterval = expirationDate.timeIntervalSinceNow
    timeRemaining.text = stringForRemainingTime((Int) (timeInterval / 60))
    
    //userName.text = (streamItem["user"] as? PFObject)["name"] as? String
  }
  
  class func heightForCell(description: String) -> CGFloat {
    let screenWidth = UIScreen.mainScreen().bounds.size.width

    let sampleDescriptionLabel: UILabel = UILabel(frame: CGRectMake(0, 0, screenWidth - leftRightPadding, 0))
    sampleDescriptionLabel.text = description
    sampleDescriptionLabel.font = Styles.Fonts.Body.Normal.Large
    sampleDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    sampleDescriptionLabel.numberOfLines = 0
    sampleDescriptionLabel.sizeToFit()
    
    return sampleDescriptionLabel.frame.size.height + topBottomPadding + userPhotoHeight
  }

}
