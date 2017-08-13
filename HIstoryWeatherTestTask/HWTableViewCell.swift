//
//  HWTableViewCell.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/5/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit

class HWTableViewCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var tmaxLabel: UILabel!
    @IBOutlet weak var tminLabel: UILabel!
    
    @IBOutlet weak var af: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var sun: UILabel!
    
    func configureCell(item: WeatherModel) {
        yearLabel.text = String(item.year)
        monthLabel.text = String(item.month)
        if let tmax = item.tmax?.0 {
            tmaxLabel.text = String(tmax)
        } else {
            tmaxLabel.text = "-"
        }
    }
}

