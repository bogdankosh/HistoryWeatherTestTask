//
//  Constants.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/5/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import Foundation

struct Constants {
    
    static let baseURL = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/"
    static let endURL = "data.txt"
        
    enum destination: String {
        case aberporth
        case armagh
        case ballypatrick
        case bradford
        case braemar
        case camborne
        case cambridge
        case cardiff
        case chivenor
        case dunstaffnage
        case durham
        case eastbourne
        case eskdalemuir
        case heathrow
        case hurn
        case lerwick
        case leuchars
        case manston
        case nairn
        case newtonrigg
        case oxford
        case paisley
        case rossonwye
        case shawbury
        case sheffield
        case stornoway
        case suttonbonington
        case tiree
        case valley
        case waddington
        case wickairport
        case yeovilton
        
        var description: String {
            return self.rawValue
        }
        
        var fullPath: String {
            return Constants.baseURL + self.description + Constants.endURL
        }
        
        static let allCases = [
            aberporth,
            armagh,
            ballypatrick,
            bradford,
            braemar,
            camborne,
            cambridge,
            cardiff,
            chivenor,
            dunstaffnage,
            durham,
            eastbourne,
            eskdalemuir,
            heathrow,
            hurn,
            lerwick,
            leuchars,
            manston,
            nairn,
            newtonrigg,
            oxford,
            paisley,
            rossonwye,
            shawbury,
            sheffield,
            stornoway,
            suttonbonington,
            tiree,
            valley,
            waddington,
            wickairport,
            yeovilton
        ]
    }
}
