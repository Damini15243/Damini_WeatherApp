//
//  AppLoader.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class AppLoader {

    // MARK: Shared Instance
    static let shared: AppLoader = AppLoader()
    var activityLoader = ActivityData()

    func addLoader() {
        let size = CGSize(width: 50, height: 50)
        let color = Constants.Colors.containerColor
        let bgColor = UIColor.black.withAlphaComponent(0.4)
        self.activityLoader = ActivityData(size: size, type: .circleStrokeSpin, color: color, backgroundColor: bgColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityLoader, nil)
    }

    func removeLoader() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
}
