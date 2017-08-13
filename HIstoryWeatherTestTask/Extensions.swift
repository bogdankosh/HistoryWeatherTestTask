//
//  Extensions.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/13/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit


// - UITableViewCell Extension
extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

// - UIView fade animation

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
