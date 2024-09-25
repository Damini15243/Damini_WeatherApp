//
//  SearchResponse.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import Foundation

struct Location: Codable {
    let name: String?
    let state: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let localNames: LocalNames?

    enum CodingKeys: String, CodingKey {
        case name
        case state
        case country
        case lat
        case lon
        case localNames = "local_names"
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let elLanguage: String?
    let srLanguage: String?
    let zhLanguage: String?
    let koLanguage: String?
    let ruLanguage: String?
    let nlLanguage: String?
    let laLanguage: String?
    let faLanguage: String?
    let heLanguage: String?
    let jaLanguage: String?

    enum CodingKeys: String, CodingKey {
        case elLanguage = "el"
        case srLanguage = "sr"
        case zhLanguage = "zh"
        case koLanguage = "ko"
        case ruLanguage = "ru"
        case nlLanguage = "nl"
        case laLanguage = "la"
        case faLanguage = "fa"
        case heLanguage = "he"
        case jaLanguage = "ja"
    }
}
