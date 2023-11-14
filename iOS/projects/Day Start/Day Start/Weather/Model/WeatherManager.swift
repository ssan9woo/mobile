import Foundation

class WeatherManager {
    static let shared = WeatherManager()
    var weather: [WeatherResponse] = []
    
    func isCorrectIndex(index: Int) -> Bool {
        let isCorrect = index >= 0 && index < self.weather.count ? true : false
        return isCorrect
    }
    
    func addWeatherResponse(response: WeatherResponse) {
        self.weather.append(response)
    }
    
    func removeIndexOfWeatherResponse(index: Int) {
        self.weather.remove(at: index)
    }
}



class WeatherViewModel {
    private let manager = WeatherManager.shared
    
    var numberOfWeatherResponse: Int {
        return self.manager.weather.count
    }
    
    func indexOfWeatherResponse(index: Int) -> WeatherResponse? {
        if self.manager.isCorrectIndex(index: index) {
            return self.manager.weather[index]
        } else {
            return nil
        }
    }
    
    func addWeatherResponse(response: WeatherResponse) {
        self.manager.addWeatherResponse(response: response)
    }
    
    func removeIndexOfWeatherResponse(index: Int) {
        self.manager.removeIndexOfWeatherResponse(index: index)
    }
    
    func insertWeatherResponse(response: WeatherResponse, index: Int) {
        self.manager.weather.insert(response, at: index)
    }
    
    func replaceWeatherResponse(response: WeatherResponse, index: Int) {
        if self.manager.isCorrectIndex(index: index) {
            self.manager.weather[index] = response
        } else {
            return
        }
    }
    
    func remove(index: Int) -> WeatherResponse? {
        let removedData = self.manager.weather.remove(at: index)
        return removedData
    }
}
