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
    
    let webService: WebService

    
    init() {
        webService = WebService()
    }
    
    func load(url: URL, completion: @escaping (_ number: Int) -> Void) {
        webService.loadData(from: url) { data in
            
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
                // Returns the number of items in array of datapoints
                completion(arrayStrOfStr.count)
            }
        }
    }
    
    func parseData(from url: URL) {
        webService.loadData(from: url) { data in
            
            guard let data = data else { self.delegate?.didFailUpdateWith(error: nil);
                return }
            
            guard let stringFromData = String(data: data, encoding: .utf8) else {
                self.delegate?.didFailUpdateWith(error: nil)
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
            
            var modelData = [WeatherModel]()
            
            for (arrayIndex, array) in arrayStrOfStr.enumerated() {
                // initialize WeatherModel from line and add it to array.
                
                // Skip first some amounts of header lines
                if arrayIndex < Constants.headerLines { continue }
                
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
                    case 2: tmaxToInit = self.checkValueAndEstimation(ofDouble: item)
                    case 3: tminToInit = self.checkValueAndEstimation(ofDouble: item)
                    case 4: let temp = self.checkValueAndEstimation(ofDouble: item)
                    if temp != nil { af = (Int((temp?.0)!), temp?.1) as? (Int, Bool) }
                    case 5: rain = self.checkValueAndEstimation(ofDouble: item)
                    case 6: sun = self.checkValueAndEstimation(ofDouble: item)
                    default: break
                    }
                    
                }
                
                // Initialize Weather model from parsed data.
                let weatherModel = WeatherModel(year: yearToInit, month: monthToInit, tmax: tmaxToInit, tmin: tminToInit, af: af, rain: rain, sun: sun)
                if let model = weatherModel {
                    modelData.append(model)
                }
            }
            self.delegate?.didReceiveDataUpdates(store: modelData)
        }
    }
    
    private func checkValueAndEstimation(ofDouble string: String) -> (Double, Bool)? {
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
