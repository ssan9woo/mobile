import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var currentContainerView: UIView!
    @IBOutlet weak var hourlyContainerView: UIView!
    @IBOutlet weak var dailyContainerView: UIView!
    
    var currentView: CurrentViewController?
    var hourlyView: HourlyViewController?
    var dailyView: DailyViewController?
    var weatherResponse: WeatherResponse?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherData = self.weatherResponse else { return }
        
        if segue.identifier == "current" {
            currentView = segue.destination as? CurrentViewController
            currentView?.weatherData = weatherData
        } else if segue.identifier == "hourly" {
            hourlyView = segue.destination as? HourlyViewController
            hourlyView?.weatherData = weatherData
        } else if segue.identifier == "daily" {
            dailyView = segue.destination as? DailyViewController
            dailyView?.weatherData = weatherData
            self.dailyView?.view.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
