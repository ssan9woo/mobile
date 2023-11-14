import UIKit

class CurrentViewController: UIViewController {

    var weatherData: WeatherResponse?
    
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentFeelsLike: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentClouds: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentView()
    }
    
    func updateCurrentView() {
        self.view.layer.cornerRadius = 10
        guard let current = self.weatherData?.current, let currentLocation = weatherData?.currentLocaiton else { return }
        guard let imageName = self.weatherData?.current.weather.first?.icon else { return }
        let url = URL(string: "http://openweathermap.org/img/wn/\(imageName)@2x.png")
        
        self.currentLocation.text = currentLocation
        self.currentWeatherImage.kf.setImage(with: url)
        self.currentTemp.text = "\(Int((current.temp - 273.15).rounded())) °C"
        self.currentFeelsLike.text = "체감온도: \(Int((current.feels_like - 273.15).rounded())) °C"
        self.currentHumidity.text = "습도: \(current.humidity) %"
        self.currentClouds.text = "흐림: \(current.clouds) %"
        self.currentWindSpeed.text = "풍속: \(current.wind_speed) m/s"
    }
}
