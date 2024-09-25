//
//  Constants.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import SwiftUI

class Constants {

    class Strings {
        static let keyAPI = "81a9569d375e1fadd21b13a96489a302"
        static let url = "https://api.openweathermap.org/"
    }

    class Colors {
        static let bgColor = UIColor(red: 80.0 / 255.0, green: 168.0 / 255.0, blue: 209.0 / 255.0, alpha: 1)
        static let containerColor = UIColor(red: 208.0 / 255.0, green: 230.0 / 255.0, blue: 240.0 / 255.0, alpha: 1)
        static let shadowColor = UIColor(red: 186 / 255.0, green: 186 / 255.0, blue: 186 / 255.0, alpha: 1).withAlphaComponent(0.25).cgColor
    }
}
