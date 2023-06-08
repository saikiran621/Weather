//
//  Utils.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation
import UIKit
import MBProgressHUD


func readJSON(_ fileName:String) -> Data {
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
          } catch {
                print("JSON File Error \(fileName)")
          }
    }
    return Data()
}
func isMockEnabled() -> Bool {
    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
        return true
    }
    return false
}

func showIndicator(withTitle title: String? = "loading...", and Description:String? = "fetching weather..") {
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    let loadingIndicator = MBProgressHUD.showAdded(to: keyWindow ?? UIWindow(), animated: true)
    loadingIndicator.bezelView.color = UIColor.black
    loadingIndicator.bezelView.style = .solidColor
    loadingIndicator.contentColor = .white
    loadingIndicator.label.text = title ?? ""
    loadingIndicator.isUserInteractionEnabled = false
    loadingIndicator.detailsLabel.text = Description ?? ""
    loadingIndicator.show(animated: true)
}
func hideIndicator() {
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    MBProgressHUD.hide(for: keyWindow ?? UIWindow(), animated: true)
}
