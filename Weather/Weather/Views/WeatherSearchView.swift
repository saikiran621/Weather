//
//  WeatherSearchView.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation
import UIKit
import CoreLocation


class WeatherSearchView: UIView {

    var viewModel:WeatherViewModel?
    private lazy var tableview: UITableView = {
        var tableview: UITableView = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.estimatedRowHeight = 190.0
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorStyle = .singleLine
        tableview.register(UINib(nibName: WeatherDisplayTableCell.identifier, bundle: nil), forCellReuseIdentifier: WeatherDisplayTableCell.identifier)
        tableview.tableFooterView = UIView()
        tableview.keyboardDismissMode = .onDrag
        return tableview
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar:UISearchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search by City or State"
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.delegate = self
        searchBar.tintColor = .darkGray
        return searchBar
    }()
    private lazy var errorLabel: UILabel = {
        let errorLabel:UILabel = UILabel()
        errorLabel.textColor = .darkGray
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        return errorLabel
    }()
    
    init(viewModel: WeatherViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        configureView()
    }
    
    func configureView() {
        self.addSubview(searchBar)
        self.addSubview(tableview)
        self.addSubview(errorLabel)
        self.backgroundColor = .white
        
        //Adding programatical constraints
        searchBar.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 44)

        tableview.anchor(top: searchBar.bottomAnchor, paddingTop: 0, bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, centerX: nil, centerY: nil, width: 0, height: 0)
        
        errorLabel.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 16, right: self.trailingAnchor, paddingRight: 10, centerX: nil, centerY: self.centerYAnchor, width: 0, height: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fetchWeatherDatafromServer(coord:CLLocationCoordinate2D) {
        showIndicator()
        self.viewModel?.fetchWeatherFromServer(coordnates: coord, completion: { [weak self] in
            self?.updateView()
        })
    }
    func fetchWeatherDatafromServer(searchString:String) {
        showIndicator()
        // Get lat longs from the address given
        viewModel?.getLatLongs(cityOrState: searchString, completion: { coordinate in
            guard let coord = coordinate else {
                self.updateView(error: Constants.location_fetch_error)
                return
            }
            // [weak self] to strong retain cycles 
            self.viewModel?.fetchWeatherFromServer(coordnates: coord, completion: { [weak self] in
                if self?.viewModel?.weatherModel?.weather?.isEmpty ?? false {
                    self?.updateView(error: Constants.no_weather_data_found)
                    return
                }
                self?.updateView()
            })
        })
    }
    func updateView(error: String = "") {
        //Update UI on main thread to avoid memory leaks
        DispatchQueue.main.async {
            if error.isEmpty {
                self.tableview.reloadData()
                self.errorLabel.isHidden = true
                self.tableview.isHidden = false
            } else {
                self.errorLabel.isHidden = false
                self.tableview.isHidden = true
                self.errorLabel.text = error
            }
            hideIndicator()
        }
    }
}
extension WeatherSearchView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weatherArr.isEmpty ?? false ? 0 : 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: WeatherDisplayTableCell.identifier) as? WeatherDisplayTableCell
        guard let model = viewModel?.weatherModel else {return UITableViewCell()}
        itemCell?.configureCell(model: model)
        return itemCell ?? UITableViewCell()
    }
}




extension WeatherSearchView : UISearchBarDelegate, UITextFieldDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchWeatherDatafromServer(searchString: searchBar.text ?? "")
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
