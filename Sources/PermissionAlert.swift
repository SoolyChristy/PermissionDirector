//
//  PermissionAlert.swift
//  PermissionDirector
//
//  Created by SoolyChristina on 2018/10/24.
//  Copyright © 2018 SoolyChristina. All rights reserved.
//

import UIKit

public protocol PermissionAlertProtocol: AnyObject {
  /// 提供弹窗实例
  ///
  /// - Parameter type: 权限类型
  /// - Returns: 弹窗实例
  init(type: PermissionType)

  /// 展示弹窗
  func show()
}

extension PermissionAlertProtocol {
  func gotoSetting() {
    guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(settingUrl, options: [:])
    } else {
      UIApplication.shared.openURL(settingUrl)
    }
  }
}

final class PermissionAlertView: UIView {
  required init(type: PermissionType) {
    self.type = type
    super.init(frame: CGRect())
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemente")
  }

  private func setupUI() {
    translatesAutoresizingMaskIntoConstraints = false

    let coverView = UIView()
    coverView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
    self.addSubview(coverView)
    coverView.translatesAutoresizingMaskIntoConstraints = false
    coverView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    coverView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    coverView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    coverView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    let contentView = UIView()
    contentView.layer.cornerRadius = 4
    contentView.backgroundColor = .white
    self.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let data = DataSource(type: type)

    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 17))
    titleLabel.textColor = .black
    titleLabel.text = "允许访问你的“\(data.title)”"
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: scale(iPhone8Design: 18)).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

    let descriptionLabel = UILabel()
    descriptionLabel.font = UIFont.systemFont(ofSize: 16)
    descriptionLabel.textColor = .gray
    descriptionLabel.text = data.description
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(descriptionLabel)
    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: scale(iPhone8Design: 16)).isActive = true
    descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: scale(iPhone8Design: 16)).isActive = true
    descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: scale(iPhone8Design: -16)).isActive = true
    let textSize = (data.description as NSString).boundingRect(with: CGSize(width: scale(iPhone8Design: 250), height: CGFloat(MAXFLOAT)), options: [.truncatesLastVisibleLine, .usesDeviceMetrics
      , .usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)

    let cancleButton = UIButton()
    cancleButton.translatesAutoresizingMaskIntoConstraints = false
    cancleButton.setTitle("NO", for: .normal)
    cancleButton.setTitleColor(.gray, for: .normal)
    cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 16))
    cancleButton.addTarget(self, action: #selector(cancleButtonAction), for: .touchUpInside)
    contentView.addSubview(cancleButton)

    let okButton = UIButton()
    okButton.translatesAutoresizingMaskIntoConstraints = false
    okButton.setTitle("YES", for: .normal)
    okButton.setTitleColor(.black, for: .normal)
    okButton.titleLabel?.font = UIFont.systemFont(ofSize: scale(iPhone8Design: 16), weight: .medium)
    okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
    contentView.addSubview(okButton)

    cancleButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    cancleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    cancleButton.rightAnchor.constraint(equalTo: okButton.leftAnchor).isActive = true
    cancleButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    okButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    okButton.widthAnchor.constraint(equalTo: cancleButton.widthAnchor).isActive = true
    okButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

    contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    contentView.heightAnchor.constraint(equalToConstant: scale(iPhone8Design: 118) + textSize.height).isActive = true
    contentView.widthAnchor.constraint(equalToConstant: scale(iPhone8Design: 282)).isActive = true
  }

  private func scale(iPhone8Design x: CGFloat) -> CGFloat {
    return x * UIScreen.main.bounds.width / 375.0
  }

  @objc private func okButtonAction() {
    hide()
    gotoSetting()
  }

  @objc private func cancleButtonAction() {
    hide()
  }

  private func hide() {
    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 0
    }) { (_) in
      self.removeFromSuperview()
    }
  }

  private let type: PermissionType
}

extension PermissionAlertView: PermissionAlertProtocol {

  func show() {
    let window = UIApplication.shared.keyWindow ?? UIWindow()
    window.addSubview(self)
    leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
    rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
    topAnchor.constraint(equalTo: window.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
    alpha = 0
    UIView.animate(withDuration: 0.25) {
      self.alpha = 1
    }
  }
}

extension PermissionAlertView {
  private struct DataSource {
    let title: String
    let description: String
    
    init(type: PermissionType) {
      switch type {
      case .calendar:
        self.init(title: "日历", description: infoDescription(for: "NSCalendarsUsageDescription"))
      case .reminder:
        self.init(title: "提醒事项", description: infoDescription(for: "NSRemindersUsageDescription"))
      case .camera:
        self.init(title: "相机", description: infoDescription(for: "NSCameraUsageDescription"))
      case .location(let type):
        let infoKey = type == .always ? "NSLocationAlwaysAndWhenInUseUsageDescription" : "NSLocationWhenInUseUsageDescription"
        self.init(title: "定位", description: infoDescription(for: infoKey))
      case .microphone:
        self.init(title: "麦克风", description: infoDescription(for: "NSMicrophoneUsageDescription"))
      case .notification:
        self.init(title: "通知", description: "开启通知更好的使用app")
      case .phonebook:
        self.init(title: "通讯录", description: infoDescription(for: "NSContactsUsageDescription"))
      case .photo:
        self.init(title: "照片", description: infoDescription(for: "NSPhotoLibraryUsageDescription"))
      }
    }

    private init(title: String, description: String) {
      self.title = title
      self.description = description
    }
  }
}

private func infoDescription(for infoKey: String) -> String {
  guard let infoDic = Bundle.main.infoDictionary,
    let description = infoDic[infoKey] as? String else {
      return "更好的使用app"
  }
  return description
}
