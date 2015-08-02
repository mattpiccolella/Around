//
//  SelectedCategoryView.swift
//  Around
//
//  Created by Matt on 8/1/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class SelectedCategoryView: UIView {
  
  static let tappedNotification = "selectedCategoryViewTapped"
  
  var view: UIView!

  var categories: [StreamItemType]

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var filterButton: UIButton!
  
  convenience init(frame: CGRect, categories: [StreamItemType], shouldUpdate: Bool) {
    self.init(frame: frame)
    self.categories = categories
  }

  override init(frame: CGRect) {
    self.categories = []
    super.init(frame: frame)
    setupNibSubview()
  }

  required init(coder aDecoder: NSCoder) {
    self.categories = []
    super.init(coder: aDecoder)
    setupNibSubview()
  }
  
  func setupNibSubview() {
    view = loadViewFromNib()
    view.frame = bounds
    addSubview(view)
    collectionView.backgroundColor = UIColor.whiteColor()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(UINib(nibName: "SelectedCategoryCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: SelectedCategoryCell.reuseIdentifier)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("selectedCategoryViewTapped")))
    // TODO: This is temporary. Do this for now, because we want filter button to be included in above tap gesture.
    filterButton.enabled = false
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "SelectedCategoryView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    return view
  }
  
  func selectedCategoryViewTapped() {
    NSNotificationCenter.defaultCenter().postNotificationName(SelectedCategoryView.tappedNotification, object: nil)
  }
}

extension SelectedCategoryView: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let selectedCategoryCell: SelectedCategoryCell = collectionView.dequeueReusableCellWithReuseIdentifier(SelectedCategoryCell.reuseIdentifier, forIndexPath: indexPath) as! SelectedCategoryCell
    selectedCategoryCell.inflate(categories[indexPath.row])
    return selectedCategoryCell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return count(categories)
  }
}

extension SelectedCategoryView: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(SelectedCategoryCell.cellSize , SelectedCategoryCell.cellSize)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(SelectedCategoryCell.cellPadding, SelectedCategoryCell.cellPadding, SelectedCategoryCell.cellPadding, 0)
  }
}
