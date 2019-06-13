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
    
    //Create Data entry variables
    var dataEntryHousing = PieChartDataEntry(value: 0)
    var dataEntryFood = PieChartDataEntry(value: 0)
    var dataEntryLifeS = PieChartDataEntry(value: 0)
    var dataEntryDebts = PieChartDataEntry(value: 0)
    var dataEntryMiscellaneous = PieChartDataEntry(value: 0)


    var dataEntriesArray = [PieChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pie Chart Configuration
        pieChart.chartDescription?.text = "Expenses Overview"
       //setting values of the data entries
        
        let housing = 78.0 //mainUser.accounts[0].getCategoryTotal(categoryNum: 0)
        let food = 68.0//mainUser.accounts[0].getCategoryTotal(categoryNum: 1)
        let lifeStyle = 39.0//mainUser.accounts[0].getCategoryTotal(categoryNum: 2)
        let debts = 34.0//mainUser.accounts[0].getCategoryTotal(categoryNum: 3)
        let misc = 47.0 //mainUser.accounts[0].getCategoryTotal(categoryNum: 4)
        
        
        if housing > 0 {
            dataEntryHousing.value = housing
            dataEntryHousing.label = "Housing"
        }
        if food > 0{
            dataEntryFood.value = food
            dataEntryFood.label = "Food"
        }
        
        if lifeStyle > 0 {
            dataEntryLifeS.value = lifeStyle
            dataEntryLifeS.label = "Life Style"
        }
       
        if debts > 0{
            dataEntryDebts.value = debts
            dataEntryDebts.label = "Debts"
        }
        
        if misc > 0{
            dataEntryMiscellaneous.value = misc
            dataEntryMiscellaneous.label = "Misc"
        }
        
        
        dataEntriesArray = [dataEntryHousing,dataEntryFood,dataEntryLifeS,dataEntryDebts,dataEntryMiscellaneous]
        
        updateChartData()
    }
    
    
    func updateChartData(){
        //set up chart
        let chartDataSet = PieChartDataSet(entries:dataEntriesArray,label:nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        //color array for the different sections of the pie chart
        let colors = [UIColor(named:"Housing"),UIColor(named:"Food"),UIColor(named:"LifeS"),UIColor(named:"Debt"),UIColor(named:"Miscellaneous")]
        
        //Sets Colors and Data of Pie Chart
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated
    }

}
