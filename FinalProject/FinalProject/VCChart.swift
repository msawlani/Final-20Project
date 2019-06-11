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
    
    @IBOutlet weak var stepperTwo: UIStepper!
    
    
    //Create Data entry variables
    var dataEntryOne = PieChartDataEntry(value: 0)
    var dataEntryTwo = PieChartDataEntry(value: 0)
    var dataEntryThree = PieChartDataEntry(value: 0)
    var dataEntryFour = PieChartDataEntry(value: 0)


    var dataEntriesArray = [PieChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pie Chart Configuration
        pieChart.chartDescription?.text = "Income vs Expenses"
       //setting values of the data entries
        dataEntryOne.value = stepperOne.value
        dataEntryOne.label = ""
        
        dataEntryTwo.value = stepperTwo.value
        dataEntryTwo.label = ""
        
        dataEntryThree.value = 0
        dataEntryThree.label = ""
        
        dataEntryFour.value = 0
        dataEntryTwo.label = ""
        
        dataEntriesArray = [dataEntryOne,dataEntryTwo]
        
        updateChartData()
    }
    
    @IBAction func changeStepperOne(_ sender: UIStepper){
        dataEntryOne.value = sender.value
        updateChartData()
    }
    
    @IBAction func changeStepperTwo(_ sender: UIStepper){
        dataEntryTwo.value = sender.value
        updateChartData()
    }
    
    func updateChartData(){
        //set up chart
        let chartDataSet = PieChartDataSet(entries:dataEntriesArray,label:nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        //color array for the different sections of the pie chart
        let colors = [UIColor(named:"income"),UIColor(named:"expense")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated
    }

}
