//
//  AddBillViewController.swift
//  FinalProject
//
//  Created by Evelyn Lima on 5/10/19.
//  Copyright © 2018 Evelyn Lima. All rights reserved.
//

import Foundation
import UIKit

class AddBillViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var repeatCategoryTextField: UITextField!
    @IBOutlet weak var autoPaySwitch: UISwitch!
    
    public var editBill: Bill?
    public var editIndexPathRow: Int?
    
    private let datePicker = UIDatePicker()
    private let categoryPickerView = UIPickerView()
    private let repeatCategoryPickerView = UIPickerView()
    
    enum Constants {
        static let categories = ["Auto", "Cable Tv", "CellPhone", "ChildCare", "Credit Card", "Education", "Electricity", "Entertainment", "Gas","Gifts", "Home", "Insurance", "Internet","Medical", "Mortgage", "Parking", "Pets", "Rent", "Security", "Tax","Telephone", "Transportation","Water", "Other"]
        static let repeatCategories = ["Never", "Every Week", "Every 2 Weeks", "Every Month", "Every 2 Months",
                                       "Every 3 Months","Every 4 Months", "Every 6 Months", "Every Year"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        installView()
        amountTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    private func installView() {
        
        showDatePicker()
        showCategoryPicker()
        showRepeatCategoryPicker()
        editBillInicialData()
        
        doneButton.target = self
        doneButton.action = #selector(doneAction)
        amountTextField.delegate = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        repeatCategoryPickerView.delegate = self
        repeatCategoryPickerView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func editBillInicialData() {
        if let bill = editBill {
            amountTextField.text = String(describing: bill.amount)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            dateTextField.text = formatter.string(from: bill.date.createDate())
            autoPaySwitch.isOn = bill.autoPay
            categoryTextField.text = bill.category
            repeatCategoryTextField.text = bill.paymentRepeat
        }
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func doneAction() {
        
        if checkInputFields() == false {
            return
        }
        
        let bill = createBill()
       
        guard let home = self.navigationController?.viewControllers.first as? SecondViewController else {
            return
        }
        
        if let indexPathRow = editIndexPathRow {
           home.billsContainer.remove(at: indexPathRow)
        }
        
        home.billsContainer.append(bill)
        self.navigationController?.popViewController(animated: true)
    }
    
    func createBill() -> Bill {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateTextField.text ?? "") ?? Date()
        
        let calendar = Calendar.current
        let customDate = DateStruct(month: calendar.component(.month, from: date),
                                    day: calendar.component(.day, from: date),
                              year: calendar.component(.year, from: date))
        
        amountTextField.text?.removeFirst()
        
        let bill = Bill(billName:"test",
                        company: "test", amount: Float(amountTextField.text!) ?? 0,
                        date: customDate,
                        autoPay: autoPaySwitch.isOn,
                        category: categoryTextField.text!,
                        paymentRepeat: repeatCategoryTextField.text!)
        
        return bill
    }

    
    func checkInputFields() -> Bool {
         let alert = UIAlertView()
        var check = true
        if amountTextField.text?.isEmpty ?? true {
            alert.title = "Amount is Empty"
            alert.message = "Please Fill the Amount to add a Bill"
            check = false
        }
        else if dateTextField.text?.isEmpty ?? true {
            alert.title = "Date is Empty"
            alert.message = "Please Fill the Due Date to add a Bill"
            check = false
        }
        else if categoryTextField.text?.isEmpty ?? true {
            alert.title = "Category is not Selected"
            alert.message = "Please Select a Category to add a Bill"
            check = false
        }
        else if repeatCategoryTextField.text?.isEmpty ?? true {
            alert.title = "Repeat is not Selected"
            alert.message = "Please Select a Repeat Option to add a Bill"
            check = false
        }
        if check == false {
        alert.addButton(withTitle: "OK")
            alert.show()
        }
        return check
    }
    
    func showCategoryPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneCategoryPicker))
        toolbar.setItems([donePickerButton], animated: true)
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.inputAccessoryView = toolbar
    }
    func showRepeatCategoryPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneCategoryPicker))
        toolbar.setItems([donePickerButton], animated: true)
        
        repeatCategoryTextField.inputView = repeatCategoryPickerView
        repeatCategoryTextField.inputAccessoryView = toolbar
    }
    
    func showDatePicker() {
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([donePickerButton], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneCategoryPicker() {
        self.view.endEditing(true)
    }
}

extension AddBillViewController: UITextFieldDelegate {
    
    
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

extension AddBillViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return Constants.categories.count
        }
        else if pickerView == repeatCategoryPickerView{
        return Constants.repeatCategories.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return Constants.categories[row]
        }
        else if pickerView == repeatCategoryPickerView{
            return Constants.repeatCategories[row]
        }
        return " "
    }
}

extension AddBillViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            return  categoryTextField.text = Constants.categories[row]
        }
        else if pickerView == repeatCategoryPickerView{
            return repeatCategoryTextField.text = Constants.repeatCategories[row]
        }
    }
}
