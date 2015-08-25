//
//  PostHistoryViewController.swift
//  Around
//
//  Created by Matt on 8/24/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class PostHistoryViewController: BaseViewController {

  @IBOutlet var collectionView: UICollectionView!
  var refreshControl: UIRefreshControl!
  
  var postHistoryStreamItems: [PFObject] = []
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    loadPostHistory()
  }
  
  func setupCollectionView() {
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerNib(UINib(nibName: "StreamItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: StreamItemCell.reuseIdentifier)
    collectionView.bounces = true
    collectionView.alwaysBounceVertical = true
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "loadPostHistory", forControlEvents: .ValueChanged)
    collectionView.addSubview(refreshControl)
  }
  
  func loadPostHistory() {
    let query: PFQuery = getPostHistoryQuery(appDelegate.currentUser!)
    query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
      self.postHistoryStreamItems = results as! Array<PFObject>
      self.refreshControl.endRefreshing()
      self.collectionView.reloadData()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension PostHistoryViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let streamItemCell: StreamItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(StreamItemCell.reuseIdentifier, forIndexPath: indexPath) as! StreamItemCell
    streamItemCell.setup()
    streamItemCell.inflate(postHistoryStreamItems[indexPath.row], currentLocation: appDelegate.location)
    return streamItemCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return postHistoryStreamItems.count
  }
  
  
}

extension PostHistoryViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let streamItemViewController: StreamItemViewController = StreamItemViewController(nibName: "StreamItemViewController", bundle: nil, streamItem: postHistoryStreamItems[indexPath.row])
    self.navigationController?.pushViewController(streamItemViewController, animated: true)
  }
}

extension PostHistoryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellHeight: CGFloat = StreamItemCell.heightForCell(postHistoryStreamItems[indexPath.row]["description"] as! String)
    return CGSizeMake(self.view.frame.size.width, cellHeight)
  }
}
