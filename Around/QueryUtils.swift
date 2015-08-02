//
//  QueryUtils.swift
//  Around
//
//  Created by Matt on 7/16/15.
//  Copyright (c) 2015 Matthew Piccolella. All rights reserved.
//

import Foundation

let milesPerLong: CGFloat = 53.0
let milesPerLat: CGFloat = 69.0

func getStreamItems(latitude: CGFloat, longitude: CGFloat, radius: CGFloat) -> PFQuery {
  let query: PFQuery = PFQuery(className: "StreamItem")
  let maxLong: CGFloat = longitude + (radius / milesPerLong)
  let minLong: CGFloat = longitude - (radius / milesPerLong)
  let maxLat: CGFloat = latitude + (radius / milesPerLat)
  let minLat: CGFloat = latitude - (radius / milesPerLat)
  let currentTime: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
  query.whereKey("longitude", lessThan: maxLong)
  query.whereKey("longitude", greaterThan: minLong)
  query.whereKey("latitude", lessThan: maxLat)
  query.whereKey("latitude", greaterThan: minLat)
  query.whereKey("expiredTimestamp", greaterThan: currentTime)
  query.includeKey("user")
  query.includeKey("profilePicture")
  query.addDescendingOrder("postedTimestamp")
  return query
}

func getStreamItems(minPoint: CLLocationCoordinate2D, maxPoint: CLLocationCoordinate2D) -> PFQuery {
  let query: PFQuery = PFQuery(className: "StreamItem")
  let currentTime: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
  query.whereKey("longitude", greaterThan: maxPoint.longitude)
  query.whereKey("longitude", lessThan: minPoint.longitude)
  query.whereKey("latitude", lessThan: minPoint.latitude)
  query.whereKey("latitude", greaterThan: maxPoint.latitude)
  query.whereKey("expiredTimestamp", greaterThan: currentTime)
  query.includeKey("user")
  query.includeKey("profilePicture")
  query.addDescendingOrder("postedTimestamp")
  return query
}

func getStreamItems(user: PFObject) -> PFQuery {
  let query: PFQuery = PFQuery(className: "StreamItem")
  query.whereKey("userId", lessThan: user.objectId!)
  return query
}

func getUserQuery(email: String, password: String) -> PFQuery {
  let query: PFQuery = PFQuery(className: "User")
  query.whereKey("email", equalTo: email)
  query.whereKey("password", equalTo: password)
  return query
}