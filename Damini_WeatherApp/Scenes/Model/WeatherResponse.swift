//
//  WeatherResponse.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation
import UIKit

struct Temperature: Codable {
    var min: Double?
    var max: Double?
}

struct UpcomingForecastModel {
    let image: UIImage?
    let day: String?
    let minTemp: String?
    let maxTemp: String?
}

struct WeatherResponse: Codable {
    let coord: Coordinate?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain??
    let clouds: Clouds?
    let dtTimeInterval: TimeInterval?
    let sys: System?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?

    // Optionally, if you want a method to return an empty WeatherResponse:
    static func empty() -> WeatherResponse {
        WeatherResponse(
            coord: Coordinate(lon: 0, lat: 0),
            weather: [],
            base: "",
            main: Main(temp: 0, feelsLike: 0, tempMin: 0, tempMax: 0, pressure: 0, humidity: 0, seaLevel: 0, grndLevel: 0, tempKf: 0.0),
            visibility: 0,
            wind: Wind(speed: 0, deg: 0, gust: 0),
            rain: nil,
            clouds: Clouds(all: 0),
            dtTimeInterval: 0,
            sys: System(type: 0, id: 0, country: "", sunrise: 0, sunset: 0),
            timezone: 0,
            id: 0,
            name: "",
            cod: 0
        )
    }

    enum CodingKeys: String, CodingKey {
        case coord, weather, base
        case main, visibility, wind
        case rain, clouds, sys
        case dtTimeInterval = "dt"
        case timezone, id, name, cod
    }
}

struct Coordinate: Codable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case humidity, pressure
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp, tempKf = "temp_kf"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct System: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}
