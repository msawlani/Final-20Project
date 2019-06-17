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
    
    public var existingPayment: Transaction?
    public var index: Int?
    var selectedSection: String = ""
    var Sections: [String] = ["Immediate Obligations", "True Expenses", "Debt Payments", "Quality of Life Goals",
                              "Just for Fun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if let payment = existingPayment{
        paymentName.text = payment.vendorName
        paymentPrice.text = "\(payment.amount)" as String
        }
        paymentPrice.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        
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
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
        toolbar.setItems([donePickerButton], animated: true)
        
        section.inputView = pickerView
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChars = CharacterSet.decimalDigits
        let charSet = CharacterSet(charactersIn: string)
        return allowChars.isSuperset(of: charSet)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.CurrencyInputFormatting() {
            textField.text = amountString
        }
    }

    func checkInputFields() -> Bool {
        let alert = UIAlertView()
        var check = true
        if paymentPrice.text?.isEmpty ?? true {
            alert.title = "Price is Empty"
            alert.message = "Please Fill the Price to Add Transaction"
            check = false
        }
        else if paymentName.text?.isEmpty ?? true {
            alert.title = "Name is Empty"
            alert.message = "Please Fill in the Name of Transaction"
            check = false
        }
        if check == false {
            alert.addButton(withTitle: "OK")
            alert.show()
        }
        return check
    }
    
    @objc func DoneButton(){
        if checkInputFields() == false{
            return
        }
        
        let transaction = createTransaction()
        
        guard let home = self.navigationController?.viewControllers.first as? FirstViewController else {
            return
        }
        
        if let indexPathRow = index {
            home.TransactionList.remove(at: indexPathRow)
        }
        
        home.TransactionList.append(transaction)
        mainUser.accounts[0].AddTransaction(transaction: transaction)
        self.navigationController?.popViewController(animated: true)
    }
    
    func createTransaction() -> Transaction {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let calendar = Calendar.current
        let date = dateFormatter.date(from: "03/03/1994") ?? Date()
        let customDate = DateStruct(month: calendar.component(.month, from: date),
                                    day: calendar.component(.day, from: date),
                                    year: calendar.component(.year, from: date))
        //paymentPrice.text?.removeFirst()
        
        let transaction = Transaction(vendorName: paymentName.text!, category: section.text!, description: "test", amount: Double(paymentPrice.text!) ?? 0, date: customDate)
        
        
        return transaction
    }

}
extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

