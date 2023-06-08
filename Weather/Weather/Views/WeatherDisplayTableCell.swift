//
//  WeatherDisplayTableCell.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import UIKit
import SDWebImage

class WeatherDisplayTableCell: UITableViewCell {

    static let identifier = "WeatherDisplayTableCell"
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var temparatueLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        weatherImageView.layer.borderColor = UIColor.lightGray.cgColor
        weatherImageView.layer.borderWidth = 1
        weatherImageView.layer.cornerRadius = 8
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    // configureCell - added In cell instead of controller to make code cleander
    func configureCell(model: WeatherModel) {
        
        mainLabel.text = model.weather?.first?.main ?? ""
        let temparature:String = String(model.main?.temp ?? 0)
        let windSpeed:String = String(model.wind?.speed ?? 0)
        
        let lat:String = String(model.coord?.lat ?? 0)
        let lan:String = String(model.coord?.lon ?? 0)
        temparatueLabel.text = "Temp: \(temparature), Wind: \(windSpeed)"
        coordinatesLabel.text = "lat: \(lat), lon: \(lan)"
        
        if let icon = model.weather?.first?.icon {
            if let url = URL(string:"https://openweathermap.org/img/wn/\(icon)@2x.png") {
                weatherImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            }
        }else {
            weatherImageView.image = UIImage(named: "placeholder.png")
        }
    }
    
}
