//
//  StreamItemViewController.swift
//  Around
//
//  Created by Matt on 7/18/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

let metersToMiles: Double = 0.000621371

class StreamItemViewController: BaseViewController, UIGestureRecognizerDelegate {
  
  private let annotationReuseIdentifier: String = "customAnnotationId"
  
  let imageHeight: CGFloat = 40.0
  var streamItem: PFObject!
  var postCoordinate: CLLocationCoordinate2D!
  var distance: Double = 0.0
  
  let upvoteCutoff: Double = 0.2

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
    setupButtons()
    addPhotoTapGesture()
  }
  
  override func viewWillAppear(animated: Bool) {
    formatTopLevelNavBar("", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
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
    let shareText: String = streamItem["description"] as! String
    let image: UIImage = postPhoto.image!
    let activityController = UIActivityViewController(activityItems: [shareText, image], applicationActivities: nil)
    activityController.excludedActivityTypes = [UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    presentViewController(activityController, animated: true, completion: nil)
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
    mapView.userInteractionEnabled = false
    mapView.delegate = self
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
    if distance < upvoteCutoff {
      favoriteButton.setTitle("Upvote", forState: .Normal)
      favoriteButton.setTitle("Upvote", forState: .Selected)
    } else {
      favoriteButton.setTitle("Get Directions", forState: .Normal)
      favoriteButton.setTitle("Get Directions", forState: .Selected)
    }
  }
  
  func addPhotoTapGesture() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "photoTapped")
    tapGestureRecognizer.delegate = self
    postPhoto.addGestureRecognizer(tapGestureRecognizer)
    postPhoto.userInteractionEnabled = true
  }
  
  func photoTapped() {
    let imageInfo: JTSImageInfo = JTSImageInfo()
    imageInfo.image = postPhoto.image!
    imageInfo.referenceRect = postPhoto.frame
    imageInfo.referenceView = postPhoto.superview
    let imageViewer: JTSImageViewController = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.None)
    imageViewer.showFromViewController(self, transition: ._FromOriginalPosition)
  }
  
  func addDataForStreamItem() {
    postDescription.text = streamItem["description"] as? String
    if let picture: PFFile = streamItem["postPicture"] as? PFFile {
      picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
        if error == nil {
          let image: UIImage? = UIImage(data: data!)
          self.postPhoto.image = image
          self.postPhoto.contentMode = UIViewContentMode.ScaleAspectFill
          self.postPhoto.clipsToBounds = true
        }
      })
    }
    if let postUser = streamItem["user"] as? PFObject {
      userName.text = postUser["name"] as? String
      if let picture: PFFile = postUser["profilePicture"] as? PFFile {
        picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
          if error == nil {
            let image: UIImage? = UIImage(data: data!)
            self.userPhoto.image = image
          }
        })
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
      distance = postLocation.distanceFromLocation(currentLocation) * metersToMiles
      distanceLabel.text = String(format: "%.02f mi", arguments: [distance])
    } else {
      // TODO: Error state.
    }
  }

  @IBAction func upvotePost(sender: AnyObject) {
    if distance < upvoteCutoff {
      // TODO: ACtually upvote the post.
    } else {
      let place: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.streamItem["latitude"] as! Double, longitude: self.streamItem["longitude"] as! Double), addressDictionary: nil)
      let mapItem = MKMapItem(placemark: place)
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      mapItem.openInMapsWithLaunchOptions(options)
    }
  }
  @IBAction func reportPost(sender: AnyObject) {
    // TODO: Actually report this post.
  }

}

extension StreamItemViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if !annotation.isKindOfClass(MKUserLocation.self) {
      if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseIdentifier) {
        pinView.annotation = annotation
        return pinView
      } else {
        let newPinView: CustomAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseIdentifier)
        newPinView.canShowCallout = false
        let streamItemType: String = streamItem["type"] as! String
        newPinView.image = UIImage(named: "\(streamItemType)-Marker")
        return newPinView
      }
    } else {
      return nil
    }
  }
}