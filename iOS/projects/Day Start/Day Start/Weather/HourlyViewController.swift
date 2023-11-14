import Foundation
import UIKit
import Kingfisher

class HourlyViewController: UIViewController {
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    var weatherData: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        setupView()
    }
    
    func setupView() {
        self.view.layer.cornerRadius = 10
        self.hourlyCollectionView.layer.cornerRadius = 10
    }
}

extension HourlyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherData?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let hour = self.weatherData?.hourly[indexPath.item] else { return UICollectionViewCell() }
        cell.updateCell(hourly: hour)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 130)
    }
}

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourlyTime: UILabel!
    @IBOutlet weak var hourlyWeatherImage: UIImageView!
    @IBOutlet weak var hourlyTemp: UILabel!
    
    func updateCell(hourly: Hourly) {
        // [] dt 변환 후 값 넣어주기
        guard let imageName = hourly.weather.first?.icon else { return }
        let url = URL(string: "http://openweathermap.org/img/wn/\(imageName)@2x.png")
    
        self.hourlyTime.text = Date.getTime(dt: hourly.dt)
        self.hourlyWeatherImage.kf.setImage(with: url)
        self.hourlyTemp.text = "\(Int((hourly.temp - 273.15).rounded())) °C"
    }
}


