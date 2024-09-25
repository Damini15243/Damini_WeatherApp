//
//  APIHelper.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation

struct WeatherApi {
    static let key = Constants.Strings.keyAPI
}

extension WeatherApi {
    static let baseURL = Constants.Strings.url

    static func getCurrentWeatherURL(latitude: Double, longitude: Double) -> String {
        return "\(baseURL)data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)&units=metric"
    }

    static func get5daysForcastURL(latitude: Double, longitude: Double) -> String {
        return "\(baseURL)data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(key)&units=metric"
    }

    static func searchLocation(cityName: String, limit: Int = 1) -> String {
        return "\(baseURL)geo/1.0/direct?q=\(cityName)&limit=\(limit)&appid=\(key)"
    }

    static func prettyPrintJSON(data: Data) {
        do {
            // Try to convert the data into a JSON object
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

            // Convert the JSON object back to Data, but this time with pretty print option
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

            // Convert the pretty-printed data to a String for display
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString) // Print the pretty JSON string
            }
        } catch {
            print("Error pretty printing JSON: \(error.localizedDescription)")
        }
    }
}

final class NetworkManager<T: Codable> {
    static func makeAPICall(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard error == nil else {
                print(String(describing: error))
                if let error = error?.localizedDescription {
                    completion(.failure(.error(err: error)))
                }
                return
            }

            print(WeatherApi.prettyPrintJSON(data: data))

            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            } catch let err {
                print(String(describing: err))
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case decodingError(err: String)
    case error(err: String)
}
