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
    
    let availableGraphViews: [[String]] = [
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
        tableView.delegate = self

        dataSource.delegate = self
        doRequest()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doRequest()
        
    }
    
    func doRequest() {
//        navigationItem.prompt = "Loading..."
        let url = URL(string: destination.fullPath)!
        dataSource.parseData(from: url)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ChartViewController {
            destinationVC.store = store
        }
    }
}



// MARK: - UITableViewDataSource methods

extension HWViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GraphLIstTableViewCell.identifier, for: indexPath) as! GraphLIstTableViewCell
            cell.graphName.text = availableGraphViews[indexPath.row][0]
            cell.graphImage.image = UIImage(named: availableGraphViews[indexPath.row][1])

            cell.dataPointsLabel.fadeTransition(0.5)
            cell.dataPointsLabel.text = String(store.count)
            return cell
            
            
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: FrameTableViewCell.identifier, for: indexPath) as! FrameTableViewCell
//            return cell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1        // availableGraphViews.count
    }
}

// MARK: - UITableViewDelegate methods

extension HWViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if store.isEmpty {
            presentAlert(title: "No data", message: "There was a problem obtaining data points. Please, check your connection.", dismissButton: "Got it")
            return nil
        } else {
            return indexPath
        }
    }
}

// MARK: -

extension HWViewController: ParserDelegate {
    func didReceiveDataUpdates(store: [WeatherModel]) {
        var storeVar = store
        storeVar.reverse()
        self.store = storeVar
        DispatchQueue.main.async {
            self.title = self.destination.description.capitalized
            self.navigationItem.prompt = nil
        }
    }
    
    func didFailUpdateWith(error: Error?) {
        DispatchQueue.main.async {
            self.navigationItem.prompt = "Network error"
            let delayInSeconds = 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                self.navigationItem.prompt = nil
            }
        }
    }
}

