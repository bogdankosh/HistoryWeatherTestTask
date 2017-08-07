//
//  ChartViewController.swift
//  HIstoryWeatherTestTask
//
//  Created by Bogdan Koshyrets on 8/6/17.
//  Copyright © 2017 Bohdan Koshyrets. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    

    @IBOutlet var chartView: LineChartView!
    
    var numbers: [Double] = [2.2, 3.0, 3.4, 3.5, 3.2]
    var numbers2: [Double] = []
    
    var xaxis: [String] = []
    var yaxis: [Double] = []

    
    var store: [WeatherModel] = [] {
        didSet {
            print("Count of store: \(store.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numbers = setupData(data: store)
        updateGraph()
    }
    
    // Sets up the graph
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<yaxis.count {
            
            let value = ChartDataEntry(x: Double(i), y: yaxis[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Mean maximum temperature (in ºC)")
        
        line1.colors = [NSUIColor.red]
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xaxis)
        chartView.xAxis.granularity = 1
        chartView.animate(xAxisDuration: 1.0)
        
        chartView.data = data
        
        chartView.chartDescription?.text = "Data provided by data.gov.uk"
        chartView.setVisibleXRangeMaximum(50)

    }
    
    // Calculates mean maximum temp in a year
    func setupData(data: [WeatherModel]) -> [Double] {
        
        var yearStore = [Int: [Double]]()
        for model in store {
            if let temp = model.tmax?.0 {
                if yearStore[model.year] == nil {
                    yearStore[model.year] = [temp]
                } else {
                    yearStore[model.year]?.append(temp)
                }
            }
        }
        // average for year
        var yearStoreFiltered = [(key: Int, value: Double)]()
        
        for (_, year) in yearStore.enumerated() {
            if year.value.count == 12 {
                var total = 0.0
                for month in year.value {
                    total += month
                }
                let average = total/12
                yearStoreFiltered.append((key: year.key, value: average))
            }
        }
        
        ()
        let yearStoreSorted = yearStoreFiltered.sorted(by: { $0.0 < $1.0 } )
        var xaxis = [String]()
        var yaxis = [Double]()
        
        for x in yearStoreSorted {
            xaxis.append(String(x.key))
        }
        
        for y in yearStoreSorted {
            yaxis.append(y.value)
        }
        
        self.xaxis = xaxis
        self.yaxis = yaxis
        
        return [Double]()
    }
    


}
