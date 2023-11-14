import Foundation
import UIKit

class DailyViewController: UIViewController {
    @IBOutlet weak var dailyTableView: UITableView!
    var weatherData: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
//        self.view.layer.cornerRadius = 10
        self.dailyTableView.layer.cornerRadius = 10
        self.dailyTableView.separatorStyle = .none
    }
}

extension DailyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.weatherData?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dailyTableViewCell", for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
        
        guard let day = self.weatherData?.daily[indexPath.row] else { return UITableViewCell() }
        cell.updateCell(day: day)
        return cell
    }
}
class DailyTableViewCell: UITableViewCell {
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    func updateCell(day: Daily) {
        guard let imageName = day.weather.first?.icon else { return }
        let url = URL(string: "http://openweathermap.org/img/wn/\(imageName)@2x.png")
        
        self.day.text = Date.getDay(dt: day.dt)
        self.weatherImage.kf.setImage(with: url)
        self.minTemp.text = "\(Int((day.temp.min - 273.15).rounded())) °C"
        self.maxTemp.text = "\(Int((day.temp.max - 273.15).rounded())) °C"
    }
}
