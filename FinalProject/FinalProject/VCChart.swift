//
//  VCChart.swift
//  FinalProject
//
//  Created by Victor  Perez on 6/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import Charts
class VCChart: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var stepperOne: UIStepper!
    
    @IBOutlet weak var steppertTwo: UIStepper!
    
    //Temporary data sets to test pieChart
    var dataEntryOne = PieChartDataEntry(value: 0)
    var dataEntryTwo = PieChartDataEntry(value: 0)
    
    var dataEntriesArray = [PieChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//Pie Chart Configuration
        pieChart.chartDescription?.text = ""
       //setting values of the data entries to match default value of steppers
        dataEntryOne.value = stepperOne.value
        dataEntryTwo.value = steppertTwo.value
        
        dataEntriesArray = [dataEntryOne,dataEntryTwo]
        
        updateChartData()
    }
    
    @IBAction func changeStepperOne(_ sender: UIStepper){
        
    }
    
    @IBAction func changeStepperTwo(_ sender: UIStepper){
        
    }
    
    func updateChartData(){
        //set up chart
        let chartDataSet = PieChartDataSet(entries:dataEntriesArray,label:nil)
    }

}
