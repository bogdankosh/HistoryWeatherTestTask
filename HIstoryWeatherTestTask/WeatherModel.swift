//
//  WeatherModel.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/4/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let year: Int
    let month: Int
    let tmax: (Double, Bool)?   // Mean maximum temperature, bool shows if data is estimated.
    let tmin: (Double, Bool)?   // Mean minimum temperature, bool shows if data is estimated.
    let af: (Int, Bool)?        // Days of air frost, days,
    let rain: (Double, Bool)?   // Total rainfall, mm
    let sun: (Double, Bool)?       // Total sunshine duration, hours
    
    init?(year: Int, month: Int, tmax: (Double, Bool)?, tmin: (Double, Bool)?, af: (Int, Bool)?, rain: (Double, Bool)?, sun: (Double, Bool)?) {
        // Check if data is valid
        if month == 0 || year == 0 {
            return nil
        }
        
        self.year = year
        self.month = month
        self.tmax = tmax
        self.tmin = tmin
        self.af = af
        self.rain = rain
        self.sun = sun
    }
}

extension WeatherModel: CustomStringConvertible {
    var description: String {
        return "\(year), \(month), \(String(describing: tmax)), \(String(describing: tmin)), \(String(describing: af)), \(String(describing: rain)), \(String(describing: sun))"

    }
}
