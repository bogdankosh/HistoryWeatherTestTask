//
//  Parser.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/4/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import Foundation

class Parser {
    
    var delegate: ParserDelegate?
    
    
    
    func load(url: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailUpdateWith(error: error)
                return
            }
            
            if let data = data, error == nil {
                // success
                self.parse(data: data)
            }
        }
        task.resume()
    }
    
    func load(url: URL, completion: @escaping (_ number: Int) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error")
            }
            
            if let data = data {
                guard let stringFromData = String(data: data, encoding: .utf8) else {
                    return
                }
                let stringArray = stringFromData.components(separatedBy: .newlines)
                
                var arrayStrOfStr = [[String]]()
                
                for string in stringArray {
                    let stringArrayLine = string.components(separatedBy: .whitespaces)
                    let filtered = stringArrayLine.filter({!$0.isEmpty})
                    
                    if !filtered.isEmpty {
                        arrayStrOfStr.append(filtered)
                    }
                }
                completion(arrayStrOfStr.count)
            }
        }
        task.resume()

    }

    
    func parse(data: Data) {
        
        guard let stringFromData = String(data: data, encoding: .utf8) else {
            delegate?.didFailUpdateWith(error: nil)
            return
        }
        let stringArray = stringFromData.components(separatedBy: .newlines)
        
        var arrayStrOfStr = [[String]]()
        
        for string in stringArray {
            let stringArrayLine = string.components(separatedBy: .whitespaces)
            let filtered = stringArrayLine.filter({!$0.isEmpty})
            
            if !filtered.isEmpty {
                arrayStrOfStr.append(filtered)
            }
        }
        
        var data = [WeatherModel]()
        
        for (arrayIndex, array) in arrayStrOfStr.enumerated() {
            // initialize WeatherModel from line and add it to array.
            
            // Skip first 8 header lines
            if arrayIndex < 8 { continue }
            
            // Values for initialization
            var yearToInit = Int()
            var monthToInit = Int()
            var tmaxToInit: (Double, Bool)?
            var tminToInit: (Double, Bool)?
            var af: (Int, Bool)?
            var rain: (Double, Bool)?
            var sun: (Double, Bool)?
            
            for (itemIndex, item) in array.enumerated() {
                
                
                // switch for every item in array that we need.
                switch itemIndex {
                case 0:
                    if let number = Int(item) {
                        yearToInit = number
                    } else { yearToInit = 0 }
                case 1:
                    if let number = Int(item) {
                        monthToInit = number
                    } else { monthToInit = 0 }
                case 2: tmaxToInit = checkValueAndEstimation(ofDouble: item)
                case 3: tminToInit = checkValueAndEstimation(ofDouble: item)
                case 4: let temp = checkValueAndEstimation(ofDouble: item)
                    if temp != nil { af = (Int((temp?.0)!), temp?.1) as? (Int, Bool) }
                case 5: rain = checkValueAndEstimation(ofDouble: item)
                case 6: sun = checkValueAndEstimation(ofDouble: item)
                default: break
                }
                
            }
            
            // Initialize Weather model from parsed data.
            let weatherModel = WeatherModel(year: yearToInit, month: monthToInit, tmax: tmaxToInit, tmin: tminToInit, af: af, rain: rain, sun: sun)
            if let model = weatherModel {
                data.append(model)
            }
            
        }
            delegate?.didReceiveDataUpdates(store: data)
    }
    
    func checkValueAndEstimation(ofDouble string: String) -> (Double, Bool)? {
        if string == "---" { return nil }
        
        var returnValue: (Double, Bool)? = (0.0, false)
        
        var doubleVar = string
        var estimateBool = false
        
        if doubleVar.contains("*") || doubleVar.contains("#") {
            doubleVar.remove(at: doubleVar.index(before: doubleVar.endIndex))
            estimateBool = true
        }
        
        let double = Double(doubleVar)
        
        returnValue?.0 = double!
        returnValue?.1 = estimateBool
        
        return returnValue
    }
}

protocol ParserDelegate: class {
    func didReceiveDataUpdates(store: [WeatherModel])
    func didFailUpdateWith(error: Error?)
}
