import Foundation

class WeatherAPI {
    static let shared = WeatherAPI()
    let API_KEY_WEATHER = "25364466d5ba5b4956350f7b3fed5dfb"
    let API_KEY_DUST = "47ee26657cf2b73079c206e8a8433adf908d56a5"
    
    // MARK: Get Weather Data
    func getData(lat: Double, lon: Double, completionHandler: @escaping (WeatherResponse?) -> (Void)){
        let session = URLSession(configuration: .default)
        guard let requestURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(API_KEY_WEATHER)") else { return }
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(statusCode),
                  let resultData = data,
                  error == nil else {
                completionHandler(nil)
                return
            }
            let response = WeatherAPI.parseWeatherResponse(data: resultData)
            completionHandler(response)
        }
        dataTask.resume()
    }
    
    static func parseWeatherResponse(data: Data) -> WeatherResponse? {
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(WeatherResponse.self, from: data)
            return response
        } catch let error {
            print("--> error: \(error.localizedDescription)")
            return nil
        }
    }
}
