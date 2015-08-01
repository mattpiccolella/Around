//
//  CategoryCell.swift
//  Around
//
//  Created by Matt on 7/21/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import UIKit

protocol CategoryCellActionDelegate {
  func categorySelected(type: StreamItemType)
}

class CategoryCell: UIView {
  
  var view: UIView!
  
  @IBOutlet var typeButton: UIButton!
  @IBOutlet var typeLabel: UIButton!

  var type: StreamItemType!
  
  var delegate: CategoryCellActionDelegate?

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
    let nib = UINib(nibName: "CategoryCell", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    return view
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupNibSubview()
  }
  
  func setupCell(type: StreamItemType) {
    self.type = type
    view.backgroundColor = UIColor.clearColor()
    typeLabel.setTitle(type.rawValue, forState: .Normal)
    typeLabel.layer.cornerRadius = 2.0
    typeLabel.layer.borderWidth = 1.0
    typeLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
    typeLabel.titleLabel?.font = Styles.Fonts.Body.Normal.Small
    typeLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 10.0)
    typeButton.layer.cornerRadius = typeButton.frame.width / 2.0
    typeButton.layer.borderColor = View.AppColor.CGColor
    typeButton.layer.borderWidth = 1.0
    typeButton.setImage(UIImage(named: type.rawValue), forState: .Normal)
    typeButton.setImage(UIImage(named: type.rawValue), forState: .Selected)
  }

  @IBAction func categoryButtonPressed(sender: AnyObject) {
    delegate?.categorySelected(type)
  }
}
