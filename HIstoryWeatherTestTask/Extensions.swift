//
//  Extensions.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/13/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
