//
//  UIImageView.swift
//  WinkNavigation
//
//  Created by Derek Carter on 2/8/19.
//  Copyright © 2019 Derek Carter. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func addBlackGradientLayer(frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.0, 0.6]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
