//
//  UIViewExtensions.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation
import UIKit


public extension UIView {

    // this fun will help to add constraints in one line
    // we can Enhance this piece of code if needed
  func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, width: CGFloat, height: CGFloat)
    {
      translatesAutoresizingMaskIntoConstraints = false
      if let top = top {
        topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
      }
      if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
      }
      if let right = right {
        //rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
      }
      if let left = left {
        //leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
      }
      if width != 0 {
        widthAnchor.constraint(equalToConstant: width).isActive = true
      }
      if height != 0 {
        heightAnchor.constraint(equalToConstant: height).isActive = true
      }
      if let centerX = centerX {
        centerXAnchor.constraint(equalTo: centerX).isActive = true
      }
      if let centerY = centerY {
        centerYAnchor.constraint(equalTo: centerY).isActive = true
      }
    }
}
