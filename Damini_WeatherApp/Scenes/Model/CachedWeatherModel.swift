//
//  CachedWeatherModel.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 25/09/24.
//

import Foundation
import RealmSwift

class WeatherCache: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString // Unique identifier
    @Persisted var cachedForecasts: List<CachedForecast> = List<CachedForecast>()
    @Persisted var cachedWeather: CachedWeather? // Optional to allow for no cached weather

    // Function to add a forecast
    func addForecast(_ forecast: CachedForecast) {
        cachedForecasts.append(forecast)
    }
    
    // Function to set weather
    func setWeather(_ weather: CachedWeather) {
        cachedWeather = weather
    }
}

extension CachedWeather {
    func apply(_ configure: (CachedWeather) -> Void) -> CachedWeather {
        configure(self)
        return self
    }
}

class CachedForecast: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString // Unique identifier
    @Persisted var date: String = ""
    @Persisted var originalDate: String = ""
    @Persisted var tempMin: Double = 0.0
    @Persisted var tempMax: Double = 0.0
    @Persisted var humidity: Int = 0
    @Persisted var weatherDescription: String = ""
    @Persisted var icon: String = ""
}

class CachedWeather: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString // Unique identifier
    @Persisted var cityName: String = ""
    @Persisted var icon: String = ""
    @Persisted var temp: Double = 0.0
    @Persisted var wind: Double = 0.0
    @Persisted var humidity: Int = 0
    @Persisted var weatherDescription: String = ""
}
