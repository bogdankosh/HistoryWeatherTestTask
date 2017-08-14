//
//  WebRequest.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/14/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import Foundation

struct WebRequest {
    
    let session: URLSession
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
    }
    
    func loadData(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = session.dataTask(with: url) { (data, _, error) in
            if error != nil {
                return
            }
            completion(data)
        }
        task.resume()
    }
}
