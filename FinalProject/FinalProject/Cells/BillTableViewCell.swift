//
//  BillTableViewCell.swift
//  FinalProject
//
//  Created by Evelyn Lima on 5/10/19.
//  Copyright © 2018 Evelyn Lima. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: BillTableViewCell.self)
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageCategory: UIImageView!
    
    //["Housing", "Food", "Transportation", "Lifestyle", "Debts", "Miscellaneous"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
    
        let myString = formatter.string(from: date)
        return myString
       
    }
    
    
    
    func configureCell(bill: Bill) {
        
        let housingImage = UIImage(named: "HousingC")
        let foodImage =  UIImage(named: "Groceries")
        let transportationImage = UIImage(named: "TransportationC")
        let lifestyleImage =  UIImage(named: "Lifestyle")
        let debtsImage =  UIImage(named: "Debts")
        let miscellaneousImage =  UIImage(named: "MiscellaneousC")
        
        nameLabel.text = bill.billName
        amountLabel.text = "$\(String(describing: bill.amount))"
        categoryLabel.text = bill.category
        dateLabel.text = dateToString(date: bill.date.createDate())
        
        if bill.category == "Housing"{
            imageCategory.image = housingImage
        }
        else if bill.category == "Food"{
            imageCategory.image = foodImage
        }
        else if bill.category == "Transportation"{
            imageCategory.image = transportationImage
        }
        else if bill.category == "Lifestyle"{
            imageCategory.image = lifestyleImage
        }
        else if bill.category == "Debts"{
            imageCategory.image = debtsImage
        }
        else if bill.category == "Miscellaneous"{
            imageCategory.image = miscellaneousImage
        }
    }
    
}

