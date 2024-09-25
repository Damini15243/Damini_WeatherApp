//
//  CityCell.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 25/09/24.
//

import UIKit

class CityCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    
    // MARK: Class Variable
    var data: String? {
        didSet {
            self.lblCity.text = data
        }
    }

    // MARK: - Custom Methods

    private func applyStyle() {
        self.imgCity.image = UIImage(named: "imgCity")
        self.lblCity.font = .customFont(ofType: .sfProRegular, withSize: 12)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
}
