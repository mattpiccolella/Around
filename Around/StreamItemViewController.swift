//
//  StreamItemViewController.swift
//  Around
//
//  Created by Matt on 7/18/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class StreamItemViewController: BaseViewController {
  
  let imageHeight: CGFloat = 40.0
  let metersToMiles: Double = 0.000621371
  var streamItem: PFObject!
  var postCoordinate: CLLocationCoordinate2D!

  @IBOutlet var postPhoto: UIImageView!
  @IBOutlet var userPhoto: UIImageView!
  @IBOutlet var userName: UILabel!
  @IBOutlet var timeRemaining: UILabel!
  @IBOutlet var distanceLabel: UILabel!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var postDescription: UILabel!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var reportButton: UIButton!
  
  convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, streamItem: PFObject) {
    self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.streamItem = streamItem
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layoutIfNeeded()
    setupViews()
    addDataForStreamItem()
  }
  
  override func viewWillAppear(animated: Bool) {
    formatTopLevelNavBar("", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem(), color: Styles.Colors.GrayLabel)
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    // TODO: Make this a real profile image.
    let profileImage: UIImage = UIImage(named: "Share")!
    let button: UIButton = barButtonImage(profileImage)
    button.addTarget(self, action: "rightButtonPushed", forControlEvents: .TouchUpInside)
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(customView: button)
    return rightBarButton
  }
  
  func rightButtonPushed() {
    let alertController: UIAlertController = UIAlertController(title: "Share Post", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    let facebookShare: UIAlertAction = UIAlertAction(title: "Facebook", style: .Default) { (alert) -> Void in
      // TODO: Actually share to Facebook
    }
    let twitterShare: UIAlertAction = UIAlertAction(title: "Twitter", style: .Default) { (alert) -> Void in
      // TODO: Actually share to Twitter
    }
    let cancelShare: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(facebookShare)
    alertController.addAction(twitterShare)
    alertController.addAction(cancelShare)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func setupViews() {
    postDescription.font = Styles.Fonts.Body.Normal.XLarge
    userName.font = Styles.Fonts.Body.Normal.Large
    timeRemaining.font = Styles.Fonts.Body.Normal.Medium
    timeRemaining.textColor = Styles.Colors.GrayLabel
    distanceLabel.font = Styles.Fonts.Body.Normal.Large
    distanceLabel.textColor = View.AppColor
    userPhoto.layer.cornerRadius = imageHeight / 2.0
    userPhoto.layer.masksToBounds = true
    setupButtons()
    setupGestureRecognizers()
  }
  
  func setupButtons() {
    favoriteButton.layer.cornerRadius = 6.0
    favoriteButton.layer.borderWidth = 1.0
    favoriteButton.layer.borderColor = View.AppColor.CGColor!
    favoriteButton.titleLabel?.font = Styles.Fonts.Body.Normal.Large
    favoriteButton.tintColor = View.AppColor
    reportButton.layer.cornerRadius = 6.0
    reportButton.layer.borderWidth = 1.0
    reportButton.layer.borderColor = View.AppColor.CGColor!
    reportButton.titleLabel?.font = Styles.Fonts.Body.Normal.Large
    reportButton.tintColor = View.AppColor
  }
  
  func setupGestureRecognizers() {
    let mapTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapViewTapped")
    mapTapGesture.cancelsTouchesInView = false
    mapTapGesture.delaysTouchesEnded = false
    mapView.addGestureRecognizer(mapTapGesture)
  }
  
  func addDataForStreamItem() {
    postDescription.text = streamItem["description"] as? String
    if let picture: PFFile? = streamItem["postPicture"] as? PFFile {
      if let image: UIImage? = UIImage(data: picture!.getData()!) {
        postPhoto.image = image
        postPhoto.contentMode = UIViewContentMode.ScaleAspectFit
      }
    }
    setDate(streamItem["postedTimestamp"] as! Double)
    setMapMarkerAndDistance(streamItem["latitude"] as! Double, longitude: streamItem["longitude"] as! Double)
  }
  
  func setDate(timestamp: Double) {
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    timeRemaining.text = dateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: timestamp))
  }
  
  func setMapMarkerAndDistance(latitude: Double, longitude: Double) {
    let postCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: postCoord, fromEyeCoordinate: postCoord, eyeAltitude: 10000)
    mapView.camera = camera
    let marker: MKPointAnnotation = MKPointAnnotation()
    marker.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    mapView.addAnnotation(marker)
    mapView.showsUserLocation = true
    
    if let currentLocation: CLLocation = appDelegate.location {
      let postLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
      let distance = postLocation.distanceFromLocation(currentLocation) * metersToMiles
      distanceLabel.text = String(format: "%.02f mi", arguments: [distance])
    } else {
      // TODO: Error state.
    }
  }
  
  func mapViewTapped() {
    let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    let getDirections: UIAlertAction = UIAlertAction(title: "Get Directions", style: .Default) { (alert) -> Void in
      let place: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.streamItem["latitude"] as! Double, longitude: self.streamItem["longitude"] as! Double), addressDictionary: nil)
      let mapItem = MKMapItem(placemark: place)
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      mapItem.openInMapsWithLaunchOptions(options)
    }
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
      println("Cancel")
    }
    alertController.addAction(getDirections)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  @IBAction func upvotePost(sender: AnyObject) {
    // TODO: Actually upvote this post.
  }
  @IBAction func reportPost(sender: AnyObject) {
    // TODO: Actually report this post.
  }

}
