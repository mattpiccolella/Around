//
//  MapViewController.swift
//  Around
//
//  Created by Matt on 5/31/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  @IBOutlet var grayOverlay: UIView!
  @IBOutlet var composeButton: UIButton!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var selectedCategoryView: SelectedCategoryView!

  private var hasLoadedInitialMarkers: Bool = false
  private let annotationReuseIdentifier: String = "customAnnotationId"
  var postSelected: Bool = false
  var categoryPickerView: CategoryFilterView!
  var categoryFilterView: CategoryFilterView!
  
  var markerView: CustomMarkerView?
  var locationManager: CLLocationManager = CLLocationManager()
  
  let composeButtonBottomPadding: CGFloat = 50.0
  let composeButtonLeftRightPadding: CGFloat = 40.0
  let navBarHeight: CGFloat = 64.0
    
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    formatTopLevelNavBar("FILTER", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    mapView.delegate = self
    let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapViewTapped")
    tapRecognizer.delegate = self
    mapView.addGestureRecognizer(tapRecognizer)
    
    let width: CGFloat = UIScreen.mainScreen().bounds.width
    let frame: CGRect = CGRectMake(0, 100, width, CategoryFilterView.viewHeight)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshMarkers"), name: streamItemAdded, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addCategoryFilterView"), name: SelectedCategoryView.tappedNotification, object: nil)

    grayOverlay.hidden = true
    setupCategoryPickerView()
    setupCategoryFilterView()
    selectedCategoryView.hidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
    formatTopLevelNavBar("FILTER", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    if appDelegate.shouldRefreshStreamItems {
      fetchNewStreamItems() {
        self.addMapMarkers()
      }
      appDelegate.shouldRefreshStreamItems = false
    } else if !postSelected {
      addMapMarkers()
    } else {
      postSelected = false
    }
    grayOverlay.hidden = true
    hideCategoryFilterView()
    hideCategoryPickerView()
    // TODO: Look into consistency and other things.
  }
  
  override func viewDidAppear(animated: Bool) {
    checkLocationAuthorizationStatus()
  }
  
  override func filterCategories() {
    if grayOverlay.hidden {
      UIView.animateWithDuration(0.5, animations: addCategoryFilterView)
    } else {
      UIView.animateWithDuration(0.5, animations: hideCategoryFilterView)
    }
  }
  
  func addMapMarkers() {
    mapView.removeAnnotations(mapView.annotations)
    for item in appDelegate.selectedStreamItems {
      let marker: MKPointAnnotation = MKPointAnnotation()
      marker.coordinate = CLLocationCoordinate2DMake(item["latitude"]!.doubleValue, item["longitude"]!.doubleValue)
      marker.title = item.objectId
      mapView.addAnnotation(marker)
    }
  }
  
  func loadInitialStreamItems() {
    // Bad hack. We try to load only based off of whether there are any objects available.
    if count(appDelegate.selectedStreamItems) == 0 {
      fetchNewStreamItems() {
        self.addMapMarkers()
      }
    } else {
      addMapMarkers()
    }
  }
  
  // MARK: Location services.
  func checkLocationAuthorizationStatus() {
    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
      mapView.showsUserLocation = true
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func refreshMarkers() {
    fetchNewStreamItems({
      self.addMapMarkers()
    })
  }

  override func leftButtonPushed() {
    self.navigationController?.setViewControllers([appDelegate.streamViewController], animated: false)
  }

  override func leftBarButtonItem() -> UIBarButtonItem {
    let listImage: UIImage = UIImage(named: "Stream")!
    let button: UIButton = barButtonImage(listImage)
    let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: listImage, style: .Done, target: self, action: "leftButtonPushed")
    return leftBarButton
  }

  func rightButtonPushed() {
    let userSettings: UserSettingsViewController = UserSettingsViewController(nibName: "UserSettingsViewController", bundle: nil)
    navigationController?.pushViewController(userSettings, animated: true)
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    // TODO: Make this a real profile image.
    let profileImage: UIImage = UIImage(named: "Profile")!
    let button: UIButton = barButtonImage(nil)
    if let picture: PFFile = PFUser.currentUser()!["profilePicture"] as? PFFile {
      picture.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
        if error == nil {
          let image: UIImage? = UIImage(data: data!)
          button.setImage(image, forState: .Normal)
          button.setImage(image, forState: .Selected)
        }
      })
    }
    button.layer.cornerRadius = barButtonHeight / 2.0
    button.layer.masksToBounds = true
    button.addTarget(self, action: "rightButtonPushed", forControlEvents: .TouchUpInside)
    let rightBarButton: UIBarButtonItem = UIBarButtonItem(customView: button)
    return rightBarButton
  }
  
  func mapViewTapped() {
    markerView?.removeFromSuperview()
    markerView = nil
  }

  @IBAction func currentLocationButtonPressed(sender: AnyObject) {
    if let coordinate = appDelegate.location?.coordinate {
      mapView.setCenterCoordinate(coordinate, animated: true)
    }
  }

  @IBAction func composeButtonPressed(sender: AnyObject) {
    if grayOverlay.hidden {
      UIView.animateWithDuration(0.5, animations: addCategoryPickerView)
    } else {
      UIView.animateWithDuration(0.5, animations: hideCategoryPickerView)
    }
  }
  
  func findStreamItemById(objectId: String) -> PFObject? {
    for streamItem in appDelegate.selectedStreamItems {
      if streamItem.objectId == objectId {
        return streamItem
      }
    }
    return nil
  }
  
  func setupCategoryPickerView() {
    let frame: CGRect = CGRectMake(composeButtonLeftRightPadding / 2.0, composeButton.frame.origin.y - composeButtonBottomPadding - CategoryFilterView.viewHeight + CategoryFilterView.doneButtonHeight, UIScreen.mainScreen().bounds.width - composeButtonLeftRightPadding, CategoryFilterView.viewHeight)
    categoryPickerView = CategoryFilterView(frame: frame)
    categoryPickerView.setupCategoryCells(self)
    categoryPickerView.doneButton.hidden = true
  }
  
  func addCategoryPickerView() {
    markerView?.removeFromSuperview()
    markerView = nil
    grayOverlay.hidden = false
    categoryFilterView.removeFromSuperview()
    view.addSubview(self.categoryPickerView)
    composeButton.setImage(UIImage(named: "XButton"), forState: .Normal)
    composeButton.setImage(UIImage(named: "XButton"), forState: .Selected)
  }
  
  func hideCategoryPickerView() {
    self.grayOverlay.hidden = true
    self.categoryPickerView.removeFromSuperview()
    composeButton.setImage(UIImage(named: "Pinpoint"), forState: .Normal)
    composeButton.setImage(UIImage(named: "Pinpoint"), forState: .Selected)
  }
  
  func setupCategoryFilterView() {
    let frame: CGRect = CGRectMake(composeButtonLeftRightPadding / 2.0, navBarHeight, UIScreen.mainScreen().bounds.width - composeButtonLeftRightPadding, CategoryFilterView.viewHeight)
    categoryFilterView = CategoryFilterView(frame: frame)
    categoryFilterView.shouldUpdateCells = true
    categoryFilterView.setupCategoryCells(self)
    categoryFilterView.setupDoneButton(doneButtonPressed)
  }
  
  func addCategoryFilterView() {
    markerView?.removeFromSuperview()
    markerView = nil
    grayOverlay.hidden = false
    categoryFilterView.selectedCategories = appDelegate.selectedCategories
    categoryFilterView.setupCategoryCells(self)
    categoryPickerView.removeFromSuperview()
    view.addSubview(categoryFilterView)
  }
  
  func hideCategoryFilterView() {
    grayOverlay.hidden = true
    categoryFilterView.removeFromSuperview()
    selectedCategoryView.hidden = count(appDelegate.selectedCategories) == 0
    selectedCategoryView.categories = appDelegate.selectedCategories
    selectedCategoryView.collectionView.reloadData()
  }
  
  func doneButtonPressed() {
    hideCategoryFilterView()
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
    appDelegate.location = newLocation
    if !hasLoadedInitialMarkers {
      hasLoadedInitialMarkers = true
      // TODO: Make eye altitude not constant. Look for a way to do it to ensure markers are present.
      let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: newLocation.coordinate, fromEyeCoordinate: newLocation.coordinate, eyeAltitude: 10000)
      mapView.camera = camera
      appDelegate.minPoint = northWestCoordinate(mapView.visibleMapRect)
      appDelegate.maxPoint = southEastCoordinate(mapView.visibleMapRect)
      loadInitialStreamItems()
    }
  }
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    // TODO: Check whether we can show some kind of error here.
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    // TODO: Handle error.
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if !annotation.isKindOfClass(MKUserLocation.self) {
      if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseIdentifier) {
        pinView.annotation = annotation
        return pinView
      } else {
        let newPinView: CustomAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseIdentifier)
        newPinView.canShowCallout = false
        if let streamItemId: String = annotation.title {
          if let streamItem: PFObject = findStreamItemById(streamItemId) {
            let streamItemType: String = streamItem["type"] as! String
            newPinView.image = UIImage(named: "\(streamItemType)-Marker")
          }
        }
        return newPinView
      }
    } else {
      return nil
    }
  }
  
  func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
    mapView.setCenterCoordinate(view.annotation.coordinate, animated: true)
    markerView?.removeFromSuperview()
    if !view.annotation.isKindOfClass(MKUserLocation.self) {
      if let streamItem: PFObject = findStreamItemById(view.annotation.title!) {
        let calloutHeight: CGFloat = CustomMarkerView.heightForView(streamItem)
        let calloutWidth: CGFloat = self.view.frame.size.width - 40.0
        let calloutX: CGFloat = -calloutWidth / 2.0 + view.frame.size.width / 2.0
        let calloutY: CGFloat = -calloutHeight - 10.0
        let calloutFrame: CGRect = CGRectMake(calloutX, calloutY, calloutWidth, calloutHeight)
        markerView = CustomMarkerView(frame: calloutFrame)
        markerView!.setupView(streamItem, location: appDelegate.location)
        markerView!.delegate = self
        view.addSubview(markerView!)
      }
    }
  }
  
  func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    if let annotationView: MKAnnotationView = mapView.viewForAnnotation(userLocation) {
      annotationView.canShowCallout = false
    }
  }
}

extension MapViewController: CustomMarkerViewDelegate {
  func showInfoView(streamItem: PFObject) {
    postSelected = true
    let streamItemViewController: StreamItemViewController = StreamItemViewController(nibName: "StreamItemViewController", bundle: nil, streamItem: streamItem)
    self.navigationController?.pushViewController(streamItemViewController, animated: true)
  }
}

extension MapViewController: CategoryCellActionDelegate {
  func categorySelected(type: StreamItemType, added: Bool) {
    // Distinguish between between category view is present.
    if let view = categoryPickerView.superview {
      let composeView: ComposeStreamItemViewController = ComposeStreamItemViewController(nibName: "ComposeStreamItemViewController", bundle: nil, type: type)
      navigationController?.pushViewController(composeView, animated: true)
    } else {
      if added {
        appDelegate.selectedCategories.append(type)
      } else {
        appDelegate.selectedCategories.removeAtIndex(find(appDelegate.selectedCategories, type)!)
      }
    }
    filterStreamItems()
    addMapMarkers()
  }
}

extension MapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}

