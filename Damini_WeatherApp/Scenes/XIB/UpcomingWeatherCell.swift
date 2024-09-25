//
//  UpcomingWeatherCell.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import UIKit

class UpcomingWeatherCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTemp: UILabel!

    // MARK: Class Variable
    var data: UpcomingForecastModel? {
        didSet {
            self.imgWeather.image = data?.image
            self.lblDay.text = data?.day
            self.lblTemp.text = "\(data?.maxTemp ?? "") °C - \(data?.minTemp ?? "") °C"
        }
    }

    // MARK: - Custom Methods

    private func applyStyle() {
        self.lblDay.font = .customFont(ofType: .sfProRegular, withSize: 12)
        self.lblTemp.font = .customFont(ofType: .spProSemibold, withSize: 12)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
}
