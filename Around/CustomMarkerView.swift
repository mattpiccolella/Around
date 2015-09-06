//
//  CustomMarkerView.swift
//  Around
//
//  Created by Matt on 7/19/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

let customMarkerTopBottom: CGFloat = 48.0
let buttonHeight: CGFloat = 40.0
let customMarkerLeftRightPadding: CGFloat = 74.0
let customMarkerLeftRightMargin: CGFloat = 40.0

@objc
protocol CustomMarkerViewDelegate {
  func showInfoView(streamItem: PFObject)
}

class CustomMarkerView: UIView {
  
  var view: UIView!
  var streamItem: PFObject?
  var delegate: CustomMarkerViewDelegate?

  @IBOutlet var userPhoto: UIImageView!
  @IBOutlet var userName: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var postDescription: UILabel!
  @IBOutlet var distanceLabel: UILabel!
  @IBOutlet var moreInfoButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupNibSubview()
    postDescription.font = Styles.Fonts.Body.Normal.Large
    timeLabel.font = Styles.Fonts.Body.Normal.Medium
    timeLabel.textColor = Styles.Colors.GrayLabel
    userName.font = Styles.Fonts.Body.Normal.Medium
    distanceLabel.font = Styles.Fonts.Body.Medium.Large
    distanceLabel.textColor = View.AppColor
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    moreInfoButton.enabled = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNibSubview()
  }
  
  func setupView(streamItem: PFObject, location: CLLocation?) {
    self.streamItem = streamItem
    postDescription.text = streamItem["description"] as? String
    if let postUser = streamItem["user"] as? PFObject {
      userName.text = postUser["name"] as? String
      if let picture: PFFile = postUser["profilePicture"] as? PFFile {
        picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
          if error == nil {
            let image: UIImage? = UIImage(data: data!)
            self.userPhoto.image = image
          }
        })
      } else {
        // TODO: Add a default profile image here.
      }
    }

    let dateFormatter: NSDateFormatter = NSDateFormatter()
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    timeLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: streamItem["postedTimestamp"] as! Double))
    if let currentLocation: CLLocation = location {
      let postLocation: CLLocation = CLLocation(latitude: streamItem["latitude"] as! Double, longitude: streamItem["longitude"] as! Double)
      let distance = postLocation.distanceFromLocation(currentLocation) * metersToMiles
      distanceLabel.text = String(format: "%.02f mi", arguments: [distance])
    }
    view.layer.cornerRadius = 5.0
    view.layer.borderWidth = 1.0
    view.layer.borderColor = Styles.Colors.MarkerBorder.CGColor
  }
  
  func setupGestureRecognizer() {
    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("infoButtonPressed:"))
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func setupNibSubview() {
    view = loadViewFromNib()
    view.frame = bounds
    addSubview(view)
    setupGestureRecognizer()
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "CustomMarkerView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    return view
  }
  
  @IBAction func infoButtonPressed(sender: AnyObject) {
    delegate?.showInfoView(streamItem!)
  }

  class func heightForView(streamItem: PFObject) -> CGFloat {
    let screenWidth = UIScreen.mainScreen().bounds.size.width

    let sampleDescriptionLabel: UILabel = UILabel(frame: CGRectMake(0, 0, screenWidth - customMarkerLeftRightMargin - customMarkerLeftRightPadding, 0))
    sampleDescriptionLabel.text = streamItem["description"] as? String
    sampleDescriptionLabel.font = Styles.Fonts.Body.Normal.Large
    sampleDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    sampleDescriptionLabel.numberOfLines = 0
    sampleDescriptionLabel.sizeToFit()
    
    return customMarkerTopBottom + buttonHeight + sampleDescriptionLabel.frame.size.height
  }

}
