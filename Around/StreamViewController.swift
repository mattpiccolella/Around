//
//  StreamViewController.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class StreamViewController: BaseViewController {
  
  let leftRightPadding: CGFloat = 40.0
  let navBarHeight: CGFloat = 64.0
  let selectedCategoryDefaultHeight: CGFloat = 35.0
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var selectedCategoryView: SelectedCategoryView!
  var refreshControl: UIRefreshControl!
  var categoryFilterView: CategoryFilterView!
  var filterGrayOverlay: UIView!

  @IBOutlet var selectedCategoryHeight: NSLayoutConstraint!
  @IBOutlet var collectionViewTopSpacing: NSLayoutConstraint!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupCategoryFilterView()
    updateSelectedCategoryView()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addCategoryFilterView"), name: SelectedCategoryView.tappedNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewWillAppear(animated: Bool) {
    formatTopLevelNavBar("FILTER", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem(), isFilter: true)
    
    collectionView.reloadData()
    updateSelectedCategoryView()
    self.navigationItem.titleView = filterTitleView(false)
    hideCategoryFilterView()
    filterGrayOverlay.hidden = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupCollectionView() {
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerNib(UINib(nibName: "StreamItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: StreamItemCell.reuseIdentifier)
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refreshStreamItems", forControlEvents: .ValueChanged)
    collectionView.addSubview(refreshControl)
  }
  
  override func leftBarButtonItem() -> UIBarButtonItem {
    let listImage: UIImage = UIImage(named: "Map")!
    let button: UIButton = barButtonImage(listImage)
    let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: listImage, style: .Done, target: self, action: "leftButtonPushed")
    return leftBarButton
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
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
  
  override func leftButtonPushed() {
    self.navigationController?.setViewControllers([appDelegate.mapViewController], animated: false)
  }
  
  func rightButtonPushed() {
    let userSettings: UserSettingsViewController = UserSettingsViewController(nibName: "UserSettingsViewController", bundle: nil)
    navigationController?.pushViewController(userSettings, animated: true)
  }
  
  func refreshStreamItems() {
    fetchNewStreamItems { () -> Void in
      self.refreshControl.endRefreshing()
      self.collectionView.reloadData()
    }
  }
  
  // MARK: Filtering
  func setupCategoryFilterView() {
    let frame: CGRect = CGRectMake(leftRightPadding / 2.0, navBarHeight, UIScreen.mainScreen().bounds.width - leftRightPadding, CategoryFilterView.viewHeight)
    categoryFilterView = CategoryFilterView(frame: frame)
    categoryFilterView.shouldUpdateCells = true
    categoryFilterView.setupCategoryCells(self)
    categoryFilterView.setupDoneButton(doneButtonPressed)
    
    // Also add gray overlay
    let filterFrame: CGRect = CGRectMake(0, navBarHeight, UIScreen.mainScreen().bounds.width, CategoryFilterView.viewHeight)
    filterGrayOverlay = UIView(frame: filterFrame)
    filterGrayOverlay.backgroundColor = UIColor.lightGrayColor()
    filterGrayOverlay.alpha = 0.8
    filterGrayOverlay.hidden = true
    view.addSubview(filterGrayOverlay)
  }
  
  func addCategoryFilterView() {
    filterGrayOverlay.hidden = false
    categoryFilterView.selectedCategories = appDelegate.selectedCategories
    categoryFilterView.setupCategoryCells(self)
    view.addSubview(categoryFilterView)
  }
  
  func hideCategoryFilterView() {
    filterGrayOverlay.hidden = true
    categoryFilterView.removeFromSuperview()
    //selectedCategoryView.hidden = count(appDelegate.selectedCategories) == 0
    //selectedCategoryView.categories = appDelegate.selectedCategories
    //selectedCategoryView.collectionView.reloadData()
  }
  
  func doneButtonPressed() {
    self.navigationItem.titleView = filterTitleView(false)
    hideCategoryFilterView()
    updateSelectedCategoryView()
  }
  
  func updateSelectedCategoryView() {
    selectedCategoryHeight.constant = appDelegate.selectedCategories.count == 0 ? 0 : selectedCategoryDefaultHeight
    selectedCategoryView.categories = appDelegate.selectedCategories
    selectedCategoryView.collectionView.reloadData()
    collectionViewTopSpacing.constant = appDelegate.selectedCategories.count == 0 ? 0 : selectedCategoryDefaultHeight
    view.layoutIfNeeded()
  }
}

extension StreamViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let streamItemCell: StreamItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(StreamItemCell.reuseIdentifier, forIndexPath: indexPath) as! StreamItemCell
    streamItemCell.setup()
    streamItemCell.inflate(appDelegate.selectedStreamItems[indexPath.row], currentLocation: appDelegate.location)
    return streamItemCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appDelegate.selectedStreamItems.count
  }
  
  override func filterCategories() {
    // Make sure this works when we close the filter view.
    if filterGrayOverlay.hidden {
      self.navigationItem.titleView = filterTitleView(true)
      UIView.animateWithDuration(0.5, animations: addCategoryFilterView)
    } else {
      self.navigationItem.titleView = filterTitleView(false)
      UIView.animateWithDuration(0.5, animations: hideCategoryFilterView)
    }
  }
}

extension StreamViewController: CategoryCellActionDelegate {
  func categorySelected(type: StreamItemType, added: Bool) {
    if added {
      appDelegate.selectedCategories.append(type)
    } else {
      appDelegate.selectedCategories.removeAtIndex(appDelegate.selectedCategories.indexOf(type)!)
    }
    filterStreamItems()
    collectionView.reloadData()
  }
}

extension StreamViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let streamItemViewController: StreamItemViewController = StreamItemViewController(nibName: "StreamItemViewController", bundle: nil, streamItem: appDelegate.selectedStreamItems[indexPath.row])
    self.navigationController?.pushViewController(streamItemViewController, animated: true)
  }
}

extension StreamViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellHeight: CGFloat = StreamItemCell.heightForCell(appDelegate.selectedStreamItems[indexPath.row]["description"] as! String)
    return CGSizeMake(self.view.frame.size.width, cellHeight)
  }
}
