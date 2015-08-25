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
  @IBOutlet var timeContainer: UIView!
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
    timeRemaining.textColor = View.AppColor
    distanceLabel.font = Styles.Fonts.Body.Normal.Medium
    distanceLabel.textColor = View.AppColor
    userPhoto.layer.cornerRadius = userPhotoHeight / 2.0
    userPhoto.layer.masksToBounds = true
  }
  
  func inflate(streamItem: PFObject, currentLocation: CLLocation?) {
    postDescription.text = streamItem["description"] as? String
    let expirationDate: NSDate = NSDate(timeIntervalSinceReferenceDate: streamItem["expiredTimestamp"]!.doubleValue!)
    let timeInterval: NSTimeInterval = expirationDate.timeIntervalSinceNow
    timeRemaining.text = stringForRemainingTime((Int) (timeInterval / 60))
    if timeInterval < 0 {
      timeContainer.hidden = true
    } else {
      timeContainer.hidden = false
    }
    if let postUser = streamItem["user"] as? PFObject {
      userName.text = postUser["name"] as? String
    }
    if let picture: PFFile = PFUser.currentUser()!["profilePicture"] as? PFFile {
      picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
        if error == nil {
          let image: UIImage? = UIImage(data: data!)
          self.userPhoto.image = image
        }
      })
    }
    if let currentLocation: CLLocation = currentLocation {
      let postLocation: CLLocation = CLLocation(latitude: streamItem["latitude"] as! Double, longitude: streamItem["longitude"]as! Double)
      let distance = postLocation.distanceFromLocation(currentLocation) * metersToMiles
      distanceLabel.text = String(format: "%.02f mi", arguments: [distance])
    }
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
