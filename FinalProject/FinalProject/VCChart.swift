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
    var dataEntryTransportation = PieChartDataEntry(value: 0)
    var dataEntryLifeS = PieChartDataEntry(value: 0)
    var dataEntryDebts = PieChartDataEntry(value: 0)
    var dataEntryMiscellaneous = PieChartDataEntry(value: 0)


    var dataEntriesArray = [PieChartDataEntry]()

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        //Pie Chart Configuration
        pieChart.chartDescription?.text = "Expenses Overview"
       //setting values of the data entries

        
     
    let housing = mainUser.accounts[0].getCategoryTotal(categoryNum: 0)
    let food = mainUser.accounts[0].getCategoryTotal(categoryNum: 1)
    let transportation = mainUser.accounts[0].getCategoryTotal(categoryNum: 2)
    let lifeStyle = mainUser.accounts[0].getCategoryTotal(categoryNum: 3)
    let debts = mainUser.accounts[0].getCategoryTotal(categoryNum: 4)
    let misc = mainUser.accounts[0].getCategoryTotal(categoryNum: 5)
            
            
    if housing > 0 {
        dataEntryHousing.value = housing
        
        }
    if food > 0{
        dataEntryFood.value = food
        }
    if transportation > 0{
        dataEntryTransportation.value = transportation
        }
    if lifeStyle > 0 {
        dataEntryLifeS.value = lifeStyle
        }
    if debts > 0{
        dataEntryDebts.value = debts
        }

            if misc > 0{
            dataEntryMiscellaneous.value = misc
            //dataEntryMiscellaneous.label = "Misc"
            }

        }
        
        

        dataEntriesArray = [dataEntryHousing,dataEntryFood,dataEntryTransportation,dataEntryLifeS,dataEntryDebts,dataEntryMiscellaneous]

        updateChartData()
    }


    func updateChartData(){
        
        
        //set up chart
        let chartDataSet = PieChartDataSet(entries:dataEntriesArray,label:nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        //color array for the different sections of the pie chart
        let colors = [UIColor(named:"Housing"),UIColor(named:"Food"),UIColor(named:"Transportation"),UIColor(named:"LifeS"),UIColor(named:"Debt"),UIColor(named:"Miscellaneous")]

        //Sets Colors and Data of Pie Chart
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
        pieChart.data?.setDrawValues(false)
        
        
    }



}


