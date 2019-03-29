//
//  ViewController.swift
//  PermissionDirector
//
//  Created by SoolyChristina on 2018/10/22.
//  Copyright © 2018 SoolyChristina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func cameraAction(_ sender: UIButton) {
    if !PermissionDirector.isAuthorized(for: .camera) {
      PermissionDirector.requestAuthorization(for: .camera) { (result) in
        if result == .authorized {
          print("camera permission has been authorized")
        }
      }
    } else {
      showAlert(title: "camera")
    }
  }
  
  @IBAction func microhoneAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .microphone) {
      PermissionDirector.requestAuthorization(for: .microphone) { (result) in
        if result == .authorized {
          print("microphone permission has been authorized")
        }
      }
    } else {
      showAlert(title: "microphone")
    }
  }

  @IBAction func notificationAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .notification) {
      PermissionDirector.requestAuthorization(for: .notification) { (result) in
        if result == .authorized {
          print("notification permission has been authorized")
        }
      }
    } else {
      showAlert(title: "notification")
    }
  }
  
  @IBAction func phonebookAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .phonebook) {
      PermissionDirector.requestAuthorization(for: .phonebook) { (result) in
        if result == .authorized {
          print("phonebook permission has been authorized")
        }
      }
    } else {
      showAlert(title: "phonebook")
    }
  }
  @IBAction func photoAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .photo) {
      PermissionDirector.requestAuthorization(for: .photo) { (result) in
        if result == .authorized {
          print("photo library permission has been authorized")
        }
      }
    } else {
      showAlert(title: "photo library")
    }
  }
  
  @IBAction func calendarAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .calendar) {
      PermissionDirector.requestAuthorization(for: .calendar) { (result) in
        if result == .authorized {
          print("calendar permission has been authorized")
        }
      }
    } else {
      showAlert(title: "calendar")
    }
  }
  
  @IBAction func locationWhenInUseAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .location(.whenInUse)) {
      PermissionDirector.requestAuthorization(for: .location(.whenInUse)) { (result) in
        if result == .authorized {
          print("location(whenInUse) permission has been authorized")
        }
      }
    } else {
      showAlert(title: "location(whenInUse)")
    }
  }
  
  @IBAction func locationAlwaysAction(_ sender: Any) {
    if !PermissionDirector.isAuthorized(for: .location(.always)) {
      PermissionDirector.requestAuthorization(for: .location(.always)) { (result) in
        if result == .authorized {
          print("location(always) permission has been authorized")
        }
      }
    } else {
      showAlert(title: "location(always)")
    }
  }
  
  func showAlert(title: String) {
    let alert = UIAlertController(title: title, message: "\(title) permission has been authorized", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
  }

}

class PermissionToastView: UIView {
  required init(type: PermissionType) {
    super.init(frame: CGRect())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension PermissionToastView: PermissionAlertProtocol {
  func show() {
    
  }
}


