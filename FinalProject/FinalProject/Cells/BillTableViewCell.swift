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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageCategory: UIImageView!
    
    let autoImage =  UIImage(named: "Auto")
    let childImage =  UIImage(named: "ChildCare")
    let clothingImage =  UIImage(named: "Clothing")
    let cardImage =  UIImage(named: "Card")
    let diningImage =  UIImage(named: "Dining")
    let educationImage =  UIImage(named: "Education")
    let electricityImage =  UIImage(named: "Electricity")
    let entertainmentImage =  UIImage(named: "Entertainment")
    let fitnessImage =  UIImage(named: "Fitness")
    let gasImage =  UIImage(named: "Gas")
    let giftsImage =  UIImage(named: "Gift")
    let groceriesImage =  UIImage(named: "Groceries")
    let homeImage =  UIImage(named: "Housing")
    let internetImage =  UIImage(named: "Internet")
    let medicalImage =  UIImage(named: "Medical")
    let mortgageImage =  UIImage(named: "Mortgage/Rent")
    let petsImage =  UIImage(named: "Pets")
    let phoneImage =  UIImage(named: "Phone")
    let transportationImage =  UIImage(named: "Transportation")
    let vacationImage =  UIImage(named: "Vacation")
    let waterImage =  UIImage(named: "Water")
    let otherImage =  UIImage(named: "Other")
    
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
        amountLabel.text = String(describing: bill.amount)
        categoryLabel.text = bill.category
        dateLabel.text = dateToString(date: bill.date.createDate())
        
        if bill.category == "Auto"{
          imageCategory.image = autoImage
        }
        else if bill.category == "ChildCare"{
            imageCategory.image = childImage
        }
       else if bill.category == "Clothing"{
            imageCategory.image = clothingImage
        }
        else if bill.category == "Credit Card"{
            imageCategory.image = cardImage
        }
        else if bill.category == "Dining Out"{
            imageCategory.image = diningImage
        }
        else if bill.category == "Education"{
            imageCategory.image = educationImage
        }
        else if bill.category == "Electricity"{
            imageCategory.image = electricityImage
        }
        else if bill.category == "Entertainment"{
            imageCategory.image = entertainmentImage
        }
        else if bill.category == "Fitness"{
            imageCategory.image = fitnessImage
        }
        else if bill.category == "Gas"{
            imageCategory.image = gasImage
        }
        else if bill.category == "Gifts"{
            imageCategory.image = giftsImage
        }
        else if bill.category == "Groceries"{
            imageCategory.image = groceriesImage
        }
        else if bill.category == "Housing"{
            imageCategory.image = homeImage
        }
        else if bill.category == "Internet/Cable"{
            imageCategory.image = internetImage
        }
        else if bill.category == "Medical"{
            imageCategory.image = medicalImage
        }
        else if bill.category == "Mortgage/Rent"{
            imageCategory.image = mortgageImage
        }
        else if bill.category == "Pets"{
            imageCategory.image = petsImage
        }
        else if bill.category == "Phone"{
            imageCategory.image = phoneImage
        }
       
        else if bill.category == "Transportation"{
            imageCategory.image = transportationImage
        }
        else if bill.category == "Vacation"{
            imageCategory.image = vacationImage
        }
        else if bill.category == "Water"{
            imageCategory.image = waterImage
        }
        else if bill.category == "Other"{
            imageCategory.image = otherImage
        }
    }
    
}

