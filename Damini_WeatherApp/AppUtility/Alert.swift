//
//  Alert.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//
//

import UIKit

class Alert {
    static let shared = Alert()
    private init() {

    }
}

// MARK: UIAlertController
extension Alert {

    /// Show normal ok - cancel alert with action
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - actionOkTitle: Ok action button title
    ///   - actionCancelTitle: Cancel action button title
    ///   - message: Alert message
    ///   - completion: Action completion return true if action is ok else false for cancel
    func showAlert(message: String) {

        let alert: UIAlertController = UIAlertController(title: "Weather App", message: message, preferredStyle: .alert)

        let actionOk: UIAlertAction = UIAlertAction(title: "Okay", style: .default) { _ in
            print("Okay Tapped")
        }
        alert.addAction(actionOk)

        alert.view.tintColor = UIColor.black
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }

        return controller
    }
}
