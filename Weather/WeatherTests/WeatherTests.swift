//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Sai Kiran on 06/08/23.
//

import XCTest

import UIKit
import XCTest
@testable import Weather

class TopicsVCTests: XCTestCase {
    
    var subject:WeatherSearchVC!
    var viewModel = WeatherViewModel()
    override func setUp() {
        
        viewModel.apiHelper = APIHelperMock.shared
        let jsonData = readJSON("WeatherData")
        let codableModel = try? JSONDecoder().decode(WeatherModel.self, from: jsonData)
        if let model = codableModel {
            viewModel = WeatherViewModel(weatherModel: model)
            subject = WeatherSearchVC(vm: viewModel)
        }
        subject.loadView()
        subject.viewDidLoad()

    }
    
    
    func testViewController(){
        XCTAssertNotNil(subject)
        XCTAssertNotNil(subject.view)
    }
    
    func testTopicssViewProperties()
    {
        subject.searchView.layoutSubviews()
        XCTAssertNotNil(subject.searchView.layoutSubviews())
        XCTAssertNotNil(subject.searchView)
        XCTAssertNotNil(subject.searchView.viewModel)
        XCTAssertNotNil(subject.searchView.configureView())
        
    }

}
