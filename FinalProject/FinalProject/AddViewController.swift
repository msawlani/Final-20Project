//
//  AddViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 6/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentPrice: UITextField!
    @IBOutlet weak var section: UITextField!
    
    var existingBill: Transaction?
    var index = Int()
    var selectedSection: String = ""
    var Sections: [String] = ["Immediate Obligations", "True Expenses", "Debt Payments", "Quality of Life Goals",
                              "Just for Fun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        paymentName.text = existingBill?.vendorName
        paymentPrice.text = "\(existingBill?.amount)" as String
        createPickerView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Sections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = Sections[row]
        section.text = selectedSection
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Sections[row]
    }
    
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        section.inputView = pickerView
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChars = CharacterSet.decimalDigits
        let charSet = CharacterSet(charactersIn: string)
        return allowChars.isSuperset(of: charSet)
    }
    
    @IBAction func Add(_ sender: Any) {
        guard let name = self.paymentName.text else {return}
        guard let price = self.paymentPrice.text else {return}
        guard let sect = self.section.text else {return}
        
        
        
    
        
        if let existingBill = existingBill{
            if name.count != 0 && price.count != 0 && sect.count != 0{
            existingBill.vendorName = name
            existingBill.amount = Double(price) ?? 0
            
            
            }
            else{
                let alert = UIAlertController(title: "Failed to update Bill", message: "Please Fill out the Information", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }else{
//            if name.count != 0 && price.count != 0 && sect.count != 0{
//
//                bills = Bills(name: name, price: price, section: sect)
//            }
            if name.count != 0 && price.count != 0 && sect.count != 0{

            let transaction = Transaction(vendorName: name, amount: Double(price) ?? 0)
                    mainUser.accounts[0].AddTransaction(transaction: transaction)
                    TransactionList.append(transaction)
            }
            else{
                let alert = UIAlertController(title: "Failed to add Bill", message: "Please Fill out the Information", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
        
    
//            do{
//                let context = bills.managedObjectContext
//            try context?.save()
//
//            }catch{
//                print("Failed to save bill")
//            }
        
    }

    @IBAction func Cancel(_ sender: Any) {
        
    }

}
