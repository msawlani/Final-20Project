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
    let cableImage =  UIImage(named: "Cable")
    let cellImage =  UIImage(named: "Cell")
    let childImage =  UIImage(named: "Child")
    let cardImage =  UIImage(named: "Card")
    let educationImage =  UIImage(named: "Education")
    let electricityImage =  UIImage(named: "Energy")
    let entertainmentImage =  UIImage(named: "Entertainment")
    let gasImage =  UIImage(named: "Gas")
    let giftsImage =  UIImage(named: "Gifts")
    let homeImage =  UIImage(named: "Home")
    let insuranceImage =  UIImage(named: "Insurance")
    let internetImage =  UIImage(named: "Internet")
    let medicalImage =  UIImage(named: "Medical")
    let mortgageImage =  UIImage(named: "Mortgage")
    let parkingImage =  UIImage(named: "Parking")
    let petsImage =  UIImage(named: "Pets")
    let rentImage =  UIImage(named: "Rent")
    let securityImage =  UIImage(named: "Security")
    let taxImage =  UIImage(named: "Tax")
    let telephoneImage =  UIImage(named: "Telephone")
    let transportationImage =  UIImage(named: "Transportation")
    let waterImage =  UIImage(named: "Water")
    let otherImage =  UIImage(named: "Camera")
    
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
       else if bill.category == "Cable Tv"{
            imageCategory.image = cableImage
        }
        else if bill.category == "CellPhone"{
            imageCategory.image = cellImage
        }
        else if bill.category == "ChildCare"{
            imageCategory.image = childImage
        }
        else if bill.category == "Credit Card"{
            imageCategory.image = cardImage
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
        else if bill.category == "Gas"{
            imageCategory.image = gasImage
        }
        else if bill.category == "Gifts"{
            imageCategory.image = giftsImage
        }
        else if bill.category == "Home"{
            imageCategory.image = homeImage
        }
        else if bill.category == "Insurance"{
            imageCategory.image = insuranceImage
        }
        else if bill.category == "Internet"{
            imageCategory.image = internetImage
        }
        else if bill.category == "Medical"{
            imageCategory.image = medicalImage
        }
        else if bill.category == "Mortgage"{
            imageCategory.image = mortgageImage
        }
        else if bill.category == "Parking"{
            imageCategory.image = parkingImage
        }
        else if bill.category == "Pets"{
            imageCategory.image = petsImage
        }
        else if bill.category == "Rents"{
            imageCategory.image = rentImage
        }
        else if bill.category == "Security"{
            imageCategory.image = securityImage
        }
        else if bill.category == "Tax"{
            imageCategory.image = taxImage
        }
        else if bill.category == "Telephone"{
            imageCategory.image = telephoneImage
        }
        else if bill.category == "Transportation"{
            imageCategory.image = transportationImage
        }
        else if bill.category == "Water"{
            imageCategory.image = waterImage
        }
        else if bill.category == "Other"{
            imageCategory.image = otherImage
        }
    }
    
}
