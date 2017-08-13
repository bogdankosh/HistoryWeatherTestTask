//
//  ResourcesCell.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/14/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit

class ResourcesCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.detailTextLabel?.text = " "
        self.textLabel?.text = " "
    }
    
}
