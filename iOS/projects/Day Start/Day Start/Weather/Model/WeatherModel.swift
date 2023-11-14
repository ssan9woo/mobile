import Foundation

struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    var isMyLocation: Bool? = nil
    var currentLocaiton: String? = nil
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable {
    let min: Double
    let max: Double
}

