//
//  StreamViewController.swift
//  Around
//
//  Created by Matt on 7/17/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class StreamViewController: BaseViewController {
  
  @IBOutlet var collectionView: UICollectionView!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    formatTopLevelNavBar("FILTER", leftBarButton: leftBarButtonItem(), rightBarButton: rightBarButtonItem())
    setupCollectionView()
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
  }
  
  func setupFlowLayout() {
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 0.0
    flowLayout.minimumLineSpacing = 0.0
    flowLayout.scrollDirection = .Vertical
    collectionView.collectionViewLayout = flowLayout
  }
  
  override func leftBarButtonItem() -> UIBarButtonItem {
    let listImage: UIImage = UIImage(named: "Stream")!
    let button: UIButton = barButtonImage(listImage)
    let leftBarButton: UIBarButtonItem = UIBarButtonItem(image: listImage, style: .Done, target: self, action: "leftButtonPushed")
    return leftBarButton
  }
  
  func rightBarButtonItem() -> UIBarButtonItem {
    // TODO: Make this a real profile image.
    let profileImage: UIImage = UIImage(named: "Profile")!
    let button: UIButton = barButtonImage(profileImage)
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
    // TODO: Show login view controller.
  }
}

extension StreamViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let streamItemCell: StreamItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(StreamItemCell.reuseIdentifier, forIndexPath: indexPath) as! StreamItemCell
    streamItemCell.setup()
    streamItemCell.inflate(appDelegate.streamItemArray[indexPath.row])
    return streamItemCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appDelegate.streamItemArray.count
  }
  
  
}

extension StreamViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    // TODO: Show view for item.
  }
}

extension StreamViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellHeight: CGFloat = StreamItemCell.heightForCell(appDelegate.streamItemArray[indexPath.row]["description"] as! String)
    return CGSizeMake(self.view.frame.size.width, cellHeight)
  }
}
