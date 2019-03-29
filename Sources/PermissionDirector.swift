//
//  PermissionDirector.swift
//  PermissionDirector
//
//  Created by SoolyChristina on 2018/10/22.
//  Copyright © 2018 SoolyChristina. All rights reserved.
//

import Foundation

extension PermissionDirector {
  /// 检查权限是否取得授权
  ///
  /// - Parameter type: 权限类型
  /// - Returns: 是否授权
  public static func isAuthorized(for type: PermissionType) -> Bool {
    return permissionFactory(for: type).status == .authorized
  }

  /// 弹出权限弹窗询问用户是否授权
  /// 若用户未决定此权限则唤起系统权限弹窗，若用户已拒绝此权限则跳入系统设置引导用户打开权限
  ///
  /// - Parameters:
  ///   - type: 权限类型
  ///   - completionHandler: 完成回调
  public static func requestAuthorization(for type: PermissionType, completionHandler: @escaping Handler) {
    permissionFactory(for: type).requestAuthorization(completionHandler: completionHandler)
  }

  /// 弹窗类型
  /// 自定义弹窗需提供一个遵循`PermissionAlertProtocol`的类型
  /// 默认弹窗类型为 `PermissionAlertView`
  public static var alertType: PermissionAlertProtocol.Type = PermissionAlertView.self
}

extension PermissionDirector {
  private static func permissionFactory(for type: PermissionType) -> PermissionProtocol {
    switch type {
    case .microphone:
      return MicrophonePermission()
    case .photo:
      return PhotoPermission()
    case .camera:
      return CameraPermission()
    case .location(let locationType):
      return LocationPermission(type: locationType)
    case .notification:
      return NotificationPermission()
    case .phonebook:
      return PhonebookPermission()
    case .calendar:
      return CalendarPermission(type: .event)
    case .reminder:
      return CalendarPermission(type: .reminder)
    }
  }
}

public struct PermissionDirector {
  private init() {}
}
