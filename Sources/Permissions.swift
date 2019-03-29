//
//  Permissions.swift
//  PermissionDirector
//
//  Created by SoolyChristina on 2018/10/22.
//  Copyright © 2018 SoolyChristina. All rights reserved.
//

import Foundation
import EventKit
import AVFoundation
import Contacts
import UserNotifications
import NotificationCenter
import Photos

struct MicrophonePermission: PermissionProtocol {
  var status: PermissionStatus {
    let status = AVAudioSession.sharedInstance().recordPermission
    switch status {
    case .denied:
      return .denied
    case .granted:
      return .authorized
    case .undetermined:
      return .notDetermined
    default:
      return .denied
    }
  }

  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
     let alert = PermissionDirector.alertType.init(type: .microphone)
     alert.show()
     completionHandler(.unknow)
      break
    case .notDetermined:
      AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        completionHandler(granted ? .authorized : .denied)
      }
    }
  }
}

struct PhotoPermission: PermissionProtocol {
  var status: PermissionStatus {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      return .authorized
    case .denied:
      return .denied
    case .notDetermined:
      return .notDetermined
    case .restricted:
      return .restricted
    default:
      return .denied
    }
  }
  
  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .photo)
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { (status) in
        completionHandler(status == .authorized ? .authorized : .denied)
      }
    }
  }
}

struct CameraPermission: PermissionProtocol {
  var status: PermissionStatus {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .denied:
      return .denied
    case .restricted:
      return .restricted
    case .notDetermined:
      return .notDetermined
    case .authorized:
      return .authorized
    default:
      return .denied
    }
  }

  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .camera)
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { (granted) in
        granted ? completionHandler(.authorized) : completionHandler(.denied)
      }
    }
  }
}

struct LocationPermission: PermissionProtocol {
  init(type: PermissionType.LocationType) {
    self.type = type
  }

  var status: PermissionStatus {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .denied:
      return .denied
    case .notDetermined:
      return .notDetermined
    case .authorizedAlways:
      return (type == .always || type == .both) ? .authorized : .denied
    case .authorizedWhenInUse:
      return (type == .whenInUse || type == .both) ? .authorized : .denied
    case .restricted:
      return .restricted
    default:
      return .denied
    }
  }
  
  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .location(type))
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      type == .always ? locationManager.requestAlwaysAuthorization() : locationManager.requestWhenInUseAuthorization()
    }
  }

  private let type: PermissionType.LocationType
}

private let locationManager = CLLocationManager()

struct NotificationPermission: PermissionProtocol {
  var status: PermissionStatus {
    if #available(iOS 10.0, *) {
      var status = UNAuthorizationStatus.denied
      let sm = DispatchSemaphore(value: 0)
      UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        status = settings.authorizationStatus
        sm.signal()
      }
      _ = sm.wait(timeout: .now() + 10)

      switch status {
      case .authorized:
        return .authorized
      case .denied, .provisional:
        return .denied
      case .notDetermined:
        return .notDetermined
      default:
        return .denied
      }
    } else {
      return .notDetermined
    }
  }
  
  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .notification)
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, _) in
          granted ? completionHandler(.authorized) : completionHandler(.denied)
        }
      } else {
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}

struct PhonebookPermission: PermissionProtocol {
  var status: PermissionStatus {
    let status = CNContactStore .authorizationStatus(for: .contacts)
    switch status {
    case .denied:
      return .denied
    case .authorized:
      return .authorized
    case .notDetermined:
      return .notDetermined
    case .restricted:
      return .restricted
    default:
      return .denied
    }
  }
  
  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .phonebook)
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      let store = CNContactStore()
      store.requestAccess(for: .contacts) { (granted, _) in
        granted ? completionHandler(.authorized) : completionHandler(.denied)
      }
    }
  }
}

struct CalendarPermission: PermissionProtocol {
  init(type: EKEntityType) {
    self.type = type
  }

  var status: PermissionStatus {
    let status = EKEventStore.authorizationStatus(for: type)
    switch status {
    case .denied:
      return .denied
    case .authorized:
      return .authorized
    case .restricted:
      return .restricted
    case .notDetermined:
      return .notDetermined
    default:
      return .denied
    }
  }

  func requestAuthorization(completionHandler: @escaping Handler) {
    switch status {
    case .authorized:
      completionHandler(.authorized)
    case .denied, .restricted:
      let alert = PermissionDirector.alertType.init(type: .calendar)
      alert.show()
      completionHandler(.unknow)
      break
    case .notDetermined:
      let store = EKEventStore()
      store.requestAccess(to: type) { (granted, _) in
        granted ? completionHandler(.authorized) : completionHandler(.denied)
      }
    }
  }
  
  private let type: EKEntityType
}
