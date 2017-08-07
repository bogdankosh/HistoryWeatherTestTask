//
//  HWViewController.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/3/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit
import Charts

class HWViewController: UIViewController {
    
    @IBAction func resreshButton(_ sender: UIBarButtonItem) {
        doRequest()
    }
    @IBOutlet weak var tableView: UITableView!
    
    var store = [WeatherModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let availableGraphViews = [
        ["Line Graph", "lineGraph"]
    ]
    
    var dataSource = Parser()
    
    var destination: Constants.destination = .bradford {
        didSet {
            print("destination is now \(destination.description)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        dataSource.delegate = self
        doRequest()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doRequest()
        
    }
    
    func doRequest() {
        title = "Loading..."
        let url = URL(string: destination.fullPath)!
        dataSource.load(url: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ChartViewController {
            destinationVC.store = store
        }
        
    }
}



// MARK: - Data Source methods

extension HWViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GraphLIstTableViewCell.identifier, for: indexPath) as? GraphLIstTableViewCell {
            
            cell.graphName.text = availableGraphViews[indexPath.row][0]
            cell.dataPointsLabel.text = String(store.count)
            cell.graphImage.image = UIImage(named: availableGraphViews[indexPath.row][1])
        
        
        
        return cell

        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableGraphViews.count
    }
}

extension HWViewController: ParserDelegate {
    func didReceiveDataUpdates(store: [WeatherModel]) {
        var storeVar = store
        storeVar.reverse()
        self.store = storeVar
        DispatchQueue.main.async {
            self.title = self.destination.description.capitalized
        }
    }
    
    func didFailUpdateWith(error: Error?) {
        title = "Network error"
        
    }
}

