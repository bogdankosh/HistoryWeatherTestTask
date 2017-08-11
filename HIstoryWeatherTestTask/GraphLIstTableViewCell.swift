//
//  GraphLIstTableViewCell.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/7/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit

class GraphLIstTableViewCell: UITableViewCell {
    
    @IBOutlet weak var graphName: UILabel!
    @IBOutlet weak var graphImage: UIImageView!
    @IBOutlet weak var dataPointsLabel: UILabel!

    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
