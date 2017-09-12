//
//  UserDefaults.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 9/11/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import Foundation

struct UserDefaultsStore {
    static let standard = UserDefaults.standard
    
    static func save(_ value: String, by key: String) {
        standard.set(value, forKey: key)
    }
    
    static func load(by key: String) -> String? {
        return standard.string(forKey: key)
    }
}
