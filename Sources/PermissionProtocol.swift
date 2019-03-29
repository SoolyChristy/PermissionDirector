//
//  PermissionProtocol.swift
//  PermissionDirector
//
//  Created by SoolyChristina on 2018/10/22.
//  Copyright © 2018 SoolyChristina. All rights reserved.
//

import Foundation

public typealias Handler = (PermissionResult) -> ()

public enum PermissionType {

  public enum LocationType {
    case whenInUse, always, both
  }

  case microphone, photo, camera, notification, phonebook, calendar, reminder
  case location(LocationType)
}

public enum PermissionResult {
  case authorized, denied, unknow
}

enum PermissionStatus {
  case notDetermined, restricted, denied, authorized
}

protocol PermissionProtocol {
  var status: PermissionStatus { get }
  func requestAuthorization(completionHandler: @escaping Handler)
}
