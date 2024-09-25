//
//  WeatherProcessingTest.swift
//  Damini_WeatherAppTests
//
//  Created by Damini Goswami on 24/09/24.
//

import XCTest
@testable import Damini_WeatherApp

final class WeatherProcessingTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherForecastResponseDecoding() throws {
        let jsonData = """
            {
                "list": [
                    {
                        "dt": 1609459200,
                        "dt_txt": "2021-01-01 12:00:00",
                        "main": {
                            "temp": 15.0,
                            "humidity": 80
                        },
                        "weather": [
                            {
                                "description": "Clear sky",
                                "icon": "01d"
                            }
                        ]
                    }
                ]
            }
            """.data(using: .utf8)!

        // Call the helper function to decode the data
        let response = try decodeWeatherForecastResponse(from: jsonData)

        XCTAssertEqual(response.list?.count, 1)
        XCTAssertEqual(response.list?.first?.main?.temp, 15.0)
        XCTAssertEqual(response.list?.first?.weather?.first?.description, "Clear sky")
    }

    private func decodeWeatherForecastResponse(from data: Data) throws -> WeatherForecastResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(WeatherForecastResponse.self, from: data)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
