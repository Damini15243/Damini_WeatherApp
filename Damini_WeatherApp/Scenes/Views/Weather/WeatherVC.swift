//
//  WeatherVC.swift
//  Damini_WeatherApp
//
//  Created by Damini Goswami on 24/09/24.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var viewSearchBg: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewWeatherBg: UIView!
    @IBOutlet weak var lblTodaysForecast: UILabel!
    @IBOutlet weak var viewMainWeatherContainer: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblWeatherTemp: UILabel!
    @IBOutlet weak var imgWeatherTemp: UIImageView!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var imgWind: UIImageView!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var imgHumidity: UIImageView!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var viewdevider: UIView!
    @IBOutlet weak var lblUpcomingForecast: UILabel!
    @IBOutlet weak var tblUpcomingForcast: DynamicTableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tblSearch: UITableView!

    // -----------------------------------------------------------
    // MARK: - Class Variables
    var viewModel: WeatherViewModel!
    var locationManager = LocationManager()
    var city: String = ""

    deinit {
        debugPrint(self.classForCoder, "deinit")
    }

    // MARK: - Custom Method

    func setupView() {
        self.locationManager.delegate = self
        self.locationManager.requestLocationPermission()

        self.applyStyle()
        self.setupTableView()
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    func applyStyle() {
        DispatchQueue.main.async {
            self.view.backgroundColor = Constants.Colors.bgColor
            self.viewMainWeatherContainer.backgroundColor = Constants.Colors.containerColor
            self.viewMainWeatherContainer.layer.cornerRadius = 12
            self.applyShadow(view: self.viewMainWeatherContainer)

            self.viewSearchBg.backgroundColor = Constants.Colors.containerColor
            self.viewSearchBg.layer.cornerRadius = 10
            self.applyShadow(view: self.viewSearchBg)

            self.viewdevider.backgroundColor = Constants.Colors.containerColor

            self.tblUpcomingForcast.backgroundColor = Constants.Colors.containerColor
            self.tblUpcomingForcast.layer.cornerRadius = 12
            self.applyShadow(view: self.tblUpcomingForcast)

            self.tblSearch.backgroundColor = Constants.Colors.containerColor
            self.tblSearch.layer.cornerRadius = 12
            self.applyShadow(view: self.tblSearch)
        }

        self.viewSearch.isHidden = true
        self.viewSearch.backgroundColor = .clear

        self.imgWind.image = UIImage(named: "wind")
        self.imgHumidity.image = UIImage(named: "humidity")
        self.imgWeatherTemp.image = UIImage(named: "temp")

        self.lblTodaysForecast.font = .customFont(ofType: .spProSemibold, withSize: 18)
        self.lblUpcomingForecast.font = .customFont(ofType: .spProSemibold, withSize: 18)
        self.lblCity.font = .customFont(ofType: .spProSemibold, withSize: 15)
        self.lblWeatherTemp.font = .customFont(ofType: .spProSemibold, withSize: 15)
        self.lblWeatherDescription.font = .customFont(ofType: .sfProRegular, withSize: 12)
        self.lblWind.font = .customFont(ofType: .sfProRegular, withSize: 12)
        self.lblHumidity.font = .customFont(ofType: .sfProRegular, withSize: 12)
    }

    private func applyShadow(view: UIView) {
        view.layer.shadowColor = Constants.Colors.shadowColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        view.layer.shadowRadius = 30.0
        view.layer.masksToBounds = false
    }

    private func setupTableView() {
        self.tblUpcomingForcast.delegate = self
        self.tblUpcomingForcast.dataSource = self
        self.tblUpcomingForcast.backgroundColor = Constants.Colors.containerColor
        let uiNib = UINib.init(nibName: String(describing: "UpcomingWeatherCell"), bundle: nil)
        self.tblUpcomingForcast.register(uiNib, forCellReuseIdentifier: String(describing: "UpcomingWeatherCell"))

        self.tblSearch.delegate = self
        self.tblSearch.dataSource = self
        self.tblSearch.backgroundColor = Constants.Colors.containerColor
        let uiCityNib = UINib.init(nibName: String(describing: "CityCell"), bundle: nil)
        self.tblSearch.register(uiCityNib, forCellReuseIdentifier: String(describing: "CityCell"))
    }

    func updateUI() {
        if self.txtSearch.text?.isEmpty == true {
            self.txtSearch.text = self.viewModel.weather.name ?? ""
        }
        self.lblCity.text = self.viewModel.weather.name ?? ""
        self.imgWeather.image = self.viewModel.getWeatherIconFor(icon: self.viewModel.weatherIcon)
        self.lblWeatherTemp.text = "\(self.viewModel.getTempFor(self.viewModel.weather.main?.temp ?? 0.0)) °C"
        self.lblWeatherDescription.text = self.viewModel.weather.weather?.first?.description ?? ""
        self.lblWind.text = "\(self.viewModel.weather.wind?.speed ?? 0.0) km/h"
        self.lblHumidity.text = "\(self.viewModel.weather.main?.humidity ?? 0)%"
        if !self.viewModel.arrWeatherDetails.isEmpty {
            self.tblUpcomingForcast.reloadData()
        }
    }

    private func bind(to viewModel: WeatherViewModel) {
        self.viewModel.fetchCurrentWeatherResponse.bind { (result) in
            switch result {
            case .success(let data):
                print("success \(data ?? false)")
                AppLoader.shared.removeLoader()
                self.updateUI()

            case .failure(let error):
                self.viewModel.managerAPIFailure(response: error.localizedDescription)
            case .none: break
            }
        }

        self.viewModel.fetchSearchResponse.bind { (result) in
            switch result {
            case .success(let data):
                print("success \(data ?? [])")
                AppLoader.shared.removeLoader()
                self.tblSearch.reloadData()

            case .failure(let error):
                self.viewModel.managerAPIFailure(response: error.localizedDescription)
            case .none: break
            }
        }
    }

    @objc func searchCity() {
        if !(self.txtSearch.text?.isEmpty ?? false) {
            let urlString = WeatherApi.searchLocation(cityName: self.txtSearch.text ?? "", limit: 1)
            self.viewModel.searchCity(city: self.txtSearch.text ?? "", for: urlString)
        } else {
            UIView.transition(with: self.viewSearch, duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                self.viewSearch.isHidden = true
            })
        }
    }

    // -----------------------------------------------------------
    // MARK: - Action Method

    @IBAction func btnSearchTapped(_ sender: Any) {
        self.searchCity()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.viewSearch.isHidden {
            UIView.transition(with: self.viewSearch, duration: 0,
                              options: .transitionCrossDissolve,
                              animations: {
                self.viewSearch.isHidden = false
                self.btnSearch.isSelected = true
            })
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchCity), object: nil)
        self.perform(#selector(searchCity), with: nil, afterDelay: 0.5)
    }

    // -----------------------------------------------------------
    // MARK: - Life Cycle Method

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = WeatherViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bind(to: self.viewModel)
    }
}

// --------------------------------------------------------------------------------------
// MARK: - UITableView Delegate & DataSource Methods

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblUpcomingForcast {
            return self.viewModel.arrWeatherDetails.count
        } else {
            return self.viewModel.arrCities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblUpcomingForcast {
            let identifier = String(describing: "UpcomingWeatherCell")
            let cell = self.tblUpcomingForcast.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UpcomingWeatherCell
            let data = self.viewModel.arrWeatherDetails[indexPath.row]
            let image = self.viewModel.getWeatherIconFor(icon: data.icon ?? "") ?? UIImage()
            let upcomingForcast = UpcomingForecastModel(image: image,
                                                        day: data.date,
                                                        minTemp: self.viewModel.getTempFor(data.tempMin ?? 0.0),
                                                        maxTemp: self.viewModel.getTempFor(data.tempMax ?? 0.0))
            cell?.data = upcomingForcast

            return cell ?? UITableViewCell()
        } else {
            let identifier = String(describing: "CityCell")
            let cell = self.tblSearch.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CityCell
            let data = self.viewModel.arrCities[indexPath.row]
            cell?.data = data.name

            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblSearch {
            self.txtSearch.resignFirstResponder()
            let data = self.viewModel.arrCities[indexPath.row]
            let coordinates = CLLocationCoordinate2D(latitude: data.lat ?? self.viewModel.lat, longitude: data.lon ?? self.viewModel.long)
            self.viewModel.getWeather(city: data.name ?? "", coord: coordinates)

            UIView.transition(with: self.viewSearch, duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                self.viewSearch.isHidden = true
            })
        }
    }
}

extension WeatherVC: LocationManagerDelegate {
    func didUpdateAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
        case .denied, .restricted:
            print("Location permission denied or restricted")
            self.viewModel.getDefaultWeatherInfo()
        default:
            print("Location permission status: \(status)")
            self.viewModel.getDefaultWeatherInfo()
        }
    }

    func didFailWithError(error: any Error) {
        print("Failed to get location with error: \(error.localizedDescription)")
        self.viewModel.getDefaultWeatherInfo()
    }

    func didUpdateLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let city = placemark.locality {
                self.txtSearch.text = city
                self.viewModel.getWeather(city: city, coord: location.coordinate)
            } else {
                self.viewModel.getDefaultWeatherInfo()
            }
        }
    }
}
