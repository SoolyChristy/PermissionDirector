![](https://raw.githubusercontent.com/SoolyChristy/PermissionDirector/master/logo.jpg)
### 说明
- 请求从未询问的权限会弹出系统的权限窗口
- 请求用户曾经拒绝的权限会展示弹窗提示用户，用户选择同意则跳入系统设置由用户手动打开此权限
### 效果
![](https://raw.githubusercontent.com/SoolyChristy/PermissionDirector/master/shortcut.gif)

### Carthage
在```cartfile```添加
```
github "SoolyChristy/PermissionDirector"
```

### 使用
  ```swift
  if !PermissionDirector.isAuthorized(for: .camera) {
    PermissionDirector.requestAuthorization(for: .camera) { (result) in
      if result == .authorized {
        print("camera permission has been authorized")
      }
    }
  }
  ```
  ### 自定义弹窗
  - 自定义UIView实现`PermissionAlertProtocol`协议
  ```swift
  public protocol PermissionAlertProtocol: class {
    /// 提供弹窗实例
    ///
    /// - Parameter type: 权限类型
    /// - Returns: 弹窗实例
    init(type: PermissionType)

    /// 展示弹窗
    func show()
    }
  ```
  ```swift
  class PermissionHudView: UIView, PermissionAlertProtocol {
    required init(type: PermissionType) {
      super.init(frame: CGRect())
      // 你的实现
    }

    func show() {
      // 你的实现
    }
  }
  ```
  - 更改弹窗类型
```swift
PermissionDirector.alertType = PermissionHudView.self
```
