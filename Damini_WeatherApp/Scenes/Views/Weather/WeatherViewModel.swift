//
//  WeatherViewModel.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation
import CoreLocation
import UIKit
import RealmSwift

struct WeatherInfo {
    var minTemp: Double
    var maxTemp: Double
    let humidity: Int
    let description: String
    let icon: String
    let originalDate: String
}

class WeatherViewModel: NSObject {

    // MARK: - OUTPUT
    private(set) var fetchCurrentWeatherResponse = Bindable<Result<Bool?, NetworkError>>()
    private(set) var fetchSearchResponse = Bindable<Result<[Location]?, NetworkError>>()
    var arrWeatherDetails: [DailyWeather] = []
    var arrCities: [Location] = []
    var weather: WeatherResponse = WeatherResponse.empty()
    var weatherForcast: WeatherForecastResponse = WeatherForecastResponse()
    var weatherImage = UIImage()
    var lat = 40.7128
    var long = -74.0060

    var weatherIcon: String {
        return weather.weather?.first?.icon ?? ""
    }

    var temperature: String {
        return getTempFor(weather.main?.temp ?? 0)
    }

    var conditions: String {
        return weather.weather?.first?.main ?? ""
    }

    var humidity: String {
        return String(format: "%d%%", weather.main?.humidity ?? 0)
    }

    var rainChances: String {
        return String(format: "%0.1f%%", weather.rain??.oneHour ?? 0.0)
    }

    override init() {
        super.init()
    }
    
    func searchCity(city: String, for urlString: String) {
        guard let url = URL(string: urlString) else {return}
        NetworkManager<[Location]>.makeAPICall(for: url) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.arrCities.removeAll()
                    self.arrCities.append(contentsOf: response)
                    self.fetchSearchResponse.value = .success(response)
                }
            case .failure(let error):
                print(error)
                self.fetchSearchResponse.value = .failure(error)
            }
        }
    }
}

// --------------------------------------------------------------------------------------
// MARK: - View event methods

extension WeatherViewModel {
    
    func managerAPIFailure(response: String) {
        AppLoader.shared.removeLoader()
        Alert.shared.showAlert(message: response)
    }

    func getTimeFor(_ temp: Int) -> String {
        return Time.timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }

    func getDayFor(_ temp: Int) -> String {
        return Time.dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }

    func getDayNumber(_ temp: Int) -> String {
        return Time.dayNumberFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }

    func getTempFor(_ temp: Double) -> String {
        return String(format: "%1.0f", temp)
    }

    func getWeatherIconFor(icon: String) -> UIImage? {
        switch icon {
        case "01d":
            return UIImage(named: "sun")
        case "01n":
            return UIImage(named: "moon")
        case "02d":
            return UIImage(named: "cloudSun")
        case "02n":
            return UIImage(named: "cloudMoon")
        case "03d":
            return UIImage(named: "cloud")
        case "03n":
            return UIImage(named: "cloudMoon")
        case "04d":
            return UIImage(named: "cloudMax")
        case "04n":
            return UIImage(named: "cloudMoon")
        case "09d":
            return UIImage(named: "rainy")
        case "09n":
            return UIImage(named: "rainy")
        case "10d":
            return UIImage(named: "rainySun")
        case "10n":
            return UIImage(named: "rainyMoon")
        case "11d":
            return UIImage(named: "thunderstormSun")
        case "11n":
            return UIImage(named: "thunderstormMoon")
        case "13d":
            return UIImage(named: "snowy")
        case "13n":
            return UIImage(named: "snowy-2")
        case "50d":
            return UIImage(named: "tornado")
        case "50n":
            return UIImage(named: "tornado")
        default:
            return UIImage(named: "sun")
        }
    }

    // Function to process daily forecasts
    func processDailyForecasts(from response: WeatherForecastResponse) -> [DailyWeather] {
        var dailyForecasts: [DailyWeather] = []
            var dateWeatherDict: [String: WeatherInfo] = [:]

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Input format

            for weatherData in response.list ?? [] {
                if let dtTxt = weatherData.dtTxt, let date = dateFormatter.date(from: dtTxt) {
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "yyyy-MM-dd"
                    let dayString = dayFormatter.string(from: date)

                    // Initialize the dictionary entry if it doesn't exist
                    if dateWeatherDict[dayString] == nil {
                        dateWeatherDict[dayString] = WeatherInfo(
                            minTemp: weatherData.main?.tempMin ?? 0.0,
                            maxTemp: weatherData.main?.tempMax ?? 0.0,
                            humidity: weatherData.main?.humidity ?? 0,
                            description: weatherData.weather?.first?.description ?? "",
                            icon: weatherData.weather?.first?.icon ?? "", 
                            originalDate: dtTxt
                        )
                    } else {
                        // Update min and max temperatures
                        if let currentMin = dateWeatherDict[dayString]?.minTemp,
                           currentMin > (weatherData.main?.tempMin ?? 0.0) {
                            dateWeatherDict[dayString]?.minTemp = weatherData.main?.tempMin ?? 0.0
                        }
                        if let currentMax = dateWeatherDict[dayString]?.maxTemp,
                           currentMax < (weatherData.main?.tempMax ?? 0.0) {
                            dateWeatherDict[dayString]?.maxTemp = weatherData.main?.tempMax ?? 0.0
                        }
                    }
                }
            }

            // Convert the dictionary to an array of DailyWeather
            for (date, weather) in dateWeatherDict {
                // Convert date string to desired format
                let formattedDate = date.formatDateString()
                dailyForecasts.append(DailyWeather(
                    date: formattedDate, 
                    originalDate: weather.originalDate,
                    tempMin: weather.minTemp,
                    tempMax: weather.maxTemp,
                    humidity: weather.humidity,
                    weatherDescription: weather.description,
                    icon: weather.icon
                ))
            }

            return dailyForecasts
    }
}

// --------------------------------------------------------------------------------------
// MARK: - Web Services

extension WeatherViewModel {
    func getDefaultWeatherInfo() {
        let coordinates = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
        self.getWeather(city: "New York", coord: coordinates)
    }

    func getWeather(city: String, coord: CLLocationCoordinate2D?) {
        AppLoader.shared.addLoader()
        var urlString = ""
        if let coord = coord {
            urlString = WeatherApi.getCurrentWeatherURL(latitude: coord.latitude, longitude: coord.longitude)
        } else {
            urlString = WeatherApi.getCurrentWeatherURL(latitude: 53.9, longitude: 27.5667) // Minsk
        }

        if self.shouldRefreshWeatherData() {
            self.getWeatherInternal(city: city, for: urlString, lat: coord?.latitude ?? 0.0, long: coord?.longitude ?? 0.0)
        } else {
            self.arrWeatherDetails.removeAll()
            self.weather = self.fetchCachedWeatherData()
            self.arrWeatherDetails = self.fetchCachedForecasts()
            self.fetchCurrentWeatherResponse.value = .success(true)
        }
    }

    func getWeatherInternal(city: String, for urlString: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        guard let url = URL(string: urlString) else {return}
        NetworkManager<WeatherResponse>.makeAPICall(for: url) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.weather = response
                    let urlString = WeatherApi.get5daysForcastURL(latitude: lat, longitude: long)
                    self.getWeatherForcast(city: city, for: urlString)
                }
            case .failure(let error):
                print(error)
                self.fetchCurrentWeatherResponse.value = .failure(error)
            }
        }
    }

    func getWeatherForcast(city: String, for urlString: String) {
        guard let url = URL(string: urlString) else {return}
        NetworkManager<WeatherForecastResponse>.makeAPICall(for: url) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.arrWeatherDetails.removeAll()
                    let dailyForecasts = self.processDailyForecasts(from: response)

                    // Output the daily forecasts
                    for dailyForecast in dailyForecasts {
                        self.arrWeatherDetails.append(dailyForecast)
                    }
                    self.saveWeatherDataToCache(weatherData: self.weather, weatherForecast: self.arrWeatherDetails)
                    self.fetchCurrentWeatherResponse.value = .success(true)
                }
            case .failure(let error):
                print(error)
                self.fetchCurrentWeatherResponse.value = .failure(error)
            }
        }
    }
}

// MARK: - Cache Management

extension WeatherViewModel {
    func shouldRefreshWeatherData() -> Bool {
        let realmStorage = RealmStorage()
        
        // Get the WeatherCache object
        let weatherCacheResults: Results<WeatherCache> = realmStorage.get(fromEntity: WeatherCache.self)
        
        // Check if the results are empty
        guard let weatherCache = weatherCacheResults.first else {
            return true // Default to refreshing if no cache exists
        }

        // Refresh data if the first cached forecast is older than 1 hour
        if let firstCachedForecast = weatherCache.cachedForecasts.first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Ensure you have time in the format

            // Ensure that the originalDate is valid before comparing
            if let cachedDate = dateFormatter.date(from: firstCachedForecast.originalDate),
               let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date()) {
                return cachedDate < oneHourAgo
            }
        }

        return true // Default to refreshing if no forecasts exist
    }

    func saveWeatherDataToCache(weatherData: WeatherResponse, weatherForecast: [DailyWeather]) {
        let realmStorage = RealmStorage()
        
        // Create a new WeatherCache instance
        let weatherCache = WeatherCache()
        weatherCache.setWeather(CachedWeather().apply {
            $0.cityName = weatherData.name ?? ""
            $0.temp = weatherData.main?.temp ?? 0.0
            $0.wind = weatherData.wind?.speed ?? 0.0
            $0.humidity = weatherData.main?.humidity ?? 0
            $0.weatherDescription = weatherData.weather?.first?.description ?? ""
            $0.icon = weatherData.weather?.first?.icon ?? ""
        })

        for dailyWeather in weatherForecast {
            let cachedForecast = CachedForecast()
            cachedForecast.date = dailyWeather.date ?? ""
            cachedForecast.originalDate = dailyWeather.originalDate ?? ""
            cachedForecast.tempMin = dailyWeather.tempMin ?? 0.0
            cachedForecast.tempMax = dailyWeather.tempMax ?? 0.0
            cachedForecast.humidity = dailyWeather.humidity ?? 0
            cachedForecast.weatherDescription = dailyWeather.weatherDescription ?? ""
            cachedForecast.icon = dailyWeather.icon ?? ""

            // Add forecast data to the WeatherCache
            weatherCache.addForecast(cachedForecast)
        }

        // Save the WeatherCache to Realm
        do {
            try realmStorage.realm.write {
                realmStorage.realm.add(weatherCache)
            }
        } catch {
            print("Error saving weather cache to Realm: \(error.localizedDescription)")
        }
    }

    func fetchCachedWeatherData() -> WeatherResponse {
        let realmStorage = RealmStorage()

        // Fetch all cached CachedWeather instances
        let cachedWeatherData: Results<CachedWeather> = realmStorage.get(fromEntity: CachedWeather.self)

        // Create an empty WeatherResponse to fill
        var weatherResponse = WeatherResponse.empty()

        // If we have cached data, populate the WeatherResponse object
        if let cachedWeather = cachedWeatherData.first { // Assuming you only want the first cached entry
            weatherResponse = WeatherResponse(
                coord: nil, // Assuming you don't have coordinate info in CachedWeather
                weather: [Weather(id: nil, main: cachedWeather.weatherDescription, description: cachedWeather.weatherDescription, icon: cachedWeather.icon)],
                base: nil,
                main: Main(temp: cachedWeather.temp, feelsLike: nil, tempMin: nil, tempMax: nil, pressure: nil, humidity: cachedWeather.humidity, seaLevel: nil, grndLevel: nil, tempKf: nil),
                visibility: nil,
                wind: Wind(speed: nil, deg: nil, gust: nil),
                rain: nil,
                clouds: Clouds(all: nil),
                dtTimeInterval: nil, // Set to your cached timestamp if available
                sys: System(type: nil, id: nil, country: nil, sunrise: nil, sunset: nil),
                timezone: nil,
                id: nil,
                name: cachedWeather.cityName,
                cod: nil
            )
        }

        return weatherResponse
    }

    func fetchCachedForecasts() -> [DailyWeather] {
        let realmStorage = RealmStorage()

        // Fetch all cached CachedForecast instances
        let cachedForecastData: Results<CachedForecast> = realmStorage.get(fromEntity: CachedForecast.self)

        // Convert Realm objects back to DailyWeather
        var dailyWeatherData: [DailyWeather] = []

        for cachedForecast in cachedForecastData {
            let dailyWeather = DailyWeather(
                date: cachedForecast.date,
                originalDate: cachedForecast.originalDate, // Make sure this property exists in DailyWeather
                tempMin: cachedForecast.tempMin,
                tempMax: cachedForecast.tempMax,
                humidity: cachedForecast.humidity,
                weatherDescription: cachedForecast.weatherDescription,
                icon: cachedForecast.icon
            )
            dailyWeatherData.append(dailyWeather)
        }

        return dailyWeatherData
    }
}
