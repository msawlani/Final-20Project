//
//  VCChart.swift
//  FinalProject
//
//  Created by Victor  Perez on 6/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import Charts
import MBCircularProgressBar
class VCChart: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!

//Label values for legend
    @IBOutlet weak var HousingVal: UILabel!
    @IBOutlet weak var FoodVal: UILabel!
    @IBOutlet weak var TransportVal: UILabel!
    @IBOutlet weak var LifeStyleVal: UILabel!
    @IBOutlet weak var DebtsVal: UILabel!
    @IBOutlet weak var MiscVal: UILabel!
    

//Initialize data entries
    var dataEntryHousing = PieChartDataEntry(value: 0)
    var dataEntryFood = PieChartDataEntry(value: 0)
    var dataEntryTransportation = PieChartDataEntry(value: 0)
    var dataEntryLifeS = PieChartDataEntry(value: 0)
    var dataEntryDebts = PieChartDataEntry(value: 0)
    var dataEntryMiscellaneous = PieChartDataEntry(value: 0)
    var dataEntriesArray = [PieChartDataEntry]()

    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    
    
    override func viewWillAppear(_ animated: Bool){
     
        //reset progres bar value
        self.CPB.value = 0
        

    
        
        //Pie Chart Configuration
        pieChart.chartDescription?.text = "Expenses Overview"
       
        
        //setting values of the data entries

    let housing = mainUser.accounts[0].getCategoryTotal(categoryNum: 1)
        HousingVal.text = String(format: "$%.02f", housing)
    let food = mainUser.accounts[0].getCategoryTotal(categoryNum: 2)
        FoodVal.text = String(format: "$%.02f", food)
    let transportation = mainUser.accounts[0].getCategoryTotal(categoryNum: 3)
        TransportVal.text = String(format: "$%.02f", transportation)
    let lifeStyle = mainUser.accounts[0].getCategoryTotal(categoryNum: 4)
        LifeStyleVal.text = String(format: "$%.02f", lifeStyle)
    let debts = mainUser.accounts[0].getCategoryTotal(categoryNum: 5)
        DebtsVal.text = String(format: "$%.02f", debts)
    let misc = mainUser.accounts[0].getCategoryTotal(categoryNum: 6)
        MiscVal.text = String(format: "$%.02f", misc)
            
            
        dataEntryHousing.value = housing
        
        dataEntryFood.value = food
   
        dataEntryTransportation.value = transportation
        
        dataEntryLifeS.value = lifeStyle
 
        dataEntryDebts.value = debts
  
        dataEntryMiscellaneous.value = misc
        

        dataEntriesArray = [dataEntryHousing,dataEntryFood,dataEntryTransportation,dataEntryLifeS,dataEntryDebts,dataEntryMiscellaneous]
        updateChartData()
    }
    
    
    //Progress bar
    @IBOutlet weak var CPB: MBCircularProgressBarView!
    
    
    
    
        
    func updateChartData(){
        
        
        //progress animation
        UIView.animate(withDuration: 2.0){
            self.CPB.value = CGFloat(mainUser.accounts[0].getPercentage())
        }
   
        
        pieChart.data?.clearValues()
    
        //set up chart
        let chartDataSet = PieChartDataSet(entries:dataEntriesArray,label:nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        //color array for the different sections of the pie chart
        let colors = [UIColor(named:"Housing"),UIColor(named:"Food"),UIColor(named:"Transportation"),UIColor(named:"LifeS"),UIColor(named:"Debt"),UIColor(named:"Miscellaneous")]

        //Sets Colors and Data of Pie Chart
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
        pieChart.data?.setDrawValues(false)
        pieChart.legend.enabled = false
        pieChart.drawHoleEnabled = true
        pieChart.rotationEnabled = false
        
    }



}


