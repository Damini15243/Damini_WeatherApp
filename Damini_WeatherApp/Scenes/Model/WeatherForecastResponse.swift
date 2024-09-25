//
//  WeatherModel.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation

// MARK: - WeatherForecastResponse
struct WeatherForecastResponse: Codable {
    let message: Int?
    let cod: String?
    let cnt: Int?
    let list: [WeatherData]?
    let city: City?

    init(message: Int? = nil, cod: String? = nil, cnt: Int? = nil, list: [WeatherData]? = nil, city: City? = nil) {
        self.message = message
        self.cod = cod
        self.cnt = cnt
        self.list = list
        self.city = city
    }
}

struct DailyWeather: Codable {
    let date: String?
    let originalDate: String?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Int?
    let weatherDescription: String?
    let icon: String?
}

// MARK: - WeatherData
struct WeatherData: Codable {
    let clouds: Clouds?
    let wind: Wind?
    let dtTimeInterval: TimeInterval?
    let dtTxt: String?
    let main: Main?
    let weather: [Weather]?
    let pop: Double?
    let sys: Sys?
    let visibility: Int?

    enum CodingKeys: String, CodingKey {
        case clouds, wind, pop, sys, visibility
        case dtTxt = "dt_txt"
        case dtTimeInterval = "dt"
        case main, weather
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String?
}

// MARK: - City
struct City: Codable {
    let sunset: TimeInterval?
    let country: String?
    let id: Int?
    let coord: Coord?
    let population: Int?
    let timezone: Int?
    let sunrise: TimeInterval?
    let name: String?
}

// MARK: - Coord
struct Coord: Codable {
    let lat: Double?
    let lon: Double?
}
