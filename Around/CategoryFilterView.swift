//
//  CategoryFilterView.swift
//  Around
//
//  Created by Matt on 7/21/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

class CategoryFilterView: UIView {
  
  static let viewHeight: CGFloat = 240.0
  static let doneButtonHeight: CGFloat = 40.0
  
  var view: UIView!

  @IBOutlet var categoryOne: CategoryCell!
  @IBOutlet var categoryTwo: CategoryCell!
  @IBOutlet var categoryThree: CategoryCell!
  @IBOutlet var categoryFour: CategoryCell!
  @IBOutlet var categoryFive: CategoryCell!
  @IBOutlet var categorySix: CategoryCell!
  @IBOutlet var doneButton: UIButton!
  var doneButtonHandler: (() -> Void)!

  let categoryNames: [StreamItemType] = [.Food, .Shopping, .Academic, .Entertainment, .Social, .Other]
  var shouldUpdateCells: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupNibSubview()
  }
  
  func setupNibSubview() {
    view = loadViewFromNib()
    view.frame = bounds
    addSubview(view)
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "CategoryFilterView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    return view
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setupCategoryCells(delegate: CategoryCellActionDelegate) {
    let categories: [CategoryCell] = [categoryOne, categoryTwo, categoryThree, categoryFour, categoryFive, categorySix]
    for i in 0...count(categories)-1 {
      categories[i].setupCell(categoryNames[i])
      categories[i].shouldUpdate = shouldUpdateCells
      categories[i].delegate = delegate
    }
  }
  
  func setupDoneButton(completion: () -> Void) {
    doneButton.titleLabel?.font = Styles.Fonts.Title.Bold.XSmall
    doneButtonHandler = completion
  }
  
  @IBAction func doneButtonPressed(sender: AnyObject) {
    doneButtonHandler()
  }
  

}
