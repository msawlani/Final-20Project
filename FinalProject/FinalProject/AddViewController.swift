//
//  AddViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 6/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData
var selectedSection: String = ""

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {


    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentPrice: UITextField!
    @IBOutlet weak var section: UITextField!
    @IBOutlet weak var dateTextField: UITextField!

    public var existingPayment: Transaction?
    public var index: Int?
    public var indexSection: Int?

    let sectionPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    var selectedSection: String = ""
    var oldAmount: Double?
    var Sections = mainUser.categories
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        showDatePicker()


        editBillInicialData()

        

        navigationItem.title = "Add Transactions"
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(AddViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        newBackButton.setTitleTextAttributes(systemFontAttributes, for: .normal)

        paymentPrice.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneButton))
        self.navigationItem.rightBarButtonItem = doneButton

        doneButton.tintColor = UIColor.white

        createPickerView()


        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainUser.categories.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = mainUser.categories[row]
        section.text = selectedSection
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainUser.categories[row]
    }

    @objc func back(sender: UIBarButtonItem) {
        if paymentName.text?.isEmpty != true || paymentPrice.text?.isEmpty != true ||
            section.text?.isEmpty != true || dateTextField.text?.isEmpty != true || self.count > 0{
        let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
        }))


        self.present(alertController, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)

        }
    }

    func createPickerView(){


        sectionPicker.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(Done))
        toolbar.setItems([donePickerButton], animated: true)

        section.inputAccessoryView = toolbar
        section.inputView = sectionPicker
    }

    @objc func Done(){
        section.text = selectedSection
        let row = sectionPicker.selectedRow(inComponent: 0)
        pickerView(sectionPicker, didSelectRow: row, inComponent: 0)
        self.view.endEditing(true)
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

    func editBillInicialData() {
        if let transaction = existingPayment {
            
            oldAmount = transaction.amount
            let amount = String(describing: (transaction.amount * 10))
            let amountString = amount.CurrencyInputFormatting()
            paymentName.text = transaction.vendorName
            paymentPrice.text = amountString
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            dateTextField.text = formatter.string(from: transaction.date.createDate())
            section.text = transaction.category
        }
    }

    @objc func DoneButton(){
        var priceString = String((paymentPrice.text?.dropFirst())!)
        priceString = priceString.replacingOccurrences(of: ",", with: "")
        
        if checkInput() == false{
            return
        }

        let transaction = createTransaction()


        guard let home = self.navigationController?.viewControllers.first as? FirstViewController else {
            return
        }

        if let indexPathRow = index, let indexPathSection = indexSection{
            home.transactionArray[indexPathSection].TransactionList.remove(at: indexPathRow)
        }

        if  section.text == "Income"{
            transaction.amount = (Double(priceString) ?? 0)
        }
        else{
            transaction.amount = ((Double(priceString) ?? 0) * -1)
        }

        if existingPayment == nil{
            
        let alert = UIAlertController(title: "Add more?", message: "Do you want to add more transactions?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(action) in
            home.transactionArray[mainUser.categories.index(of:transaction.category)!].TransactionList.append(transaction)
            
            
            if  transaction.transactionNum != ""{
                mainUser.accounts[0].EditTransaction(newTransaction: transaction, oldAmount: self.oldAmount!)
            }
            else {
                mainUser.accounts[0].AddTransaction(transaction: transaction)
            }
            
            self.count = 0
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(ACTION) in
            home.transactionArray[mainUser.categories.index(of:transaction.category)!].TransactionList.append(transaction)
            
            
            if  transaction.transactionNum != ""{
                mainUser.accounts[0].EditTransaction(newTransaction: transaction, oldAmount: self.oldAmount!)
            }
            else {
                mainUser.accounts[0].AddTransaction(transaction: transaction)
            }
            
            self.paymentName.text = ""
            self.paymentPrice.text = ""
            self.section.text = ""
            self.dateTextField.text = ""
            self.count += 1
        }))
            self.present(alert, animated: true)

        }
        if existingPayment != nil && self.count == 0
        {
            home.transactionArray[mainUser.categories.index(of:transaction.category)!].TransactionList.append(transaction)
            
            
            if  transaction.transactionNum != ""{
                mainUser.accounts[0].EditTransaction(newTransaction: transaction, oldAmount: self.oldAmount!)
            }
            else {
                mainUser.accounts[0].AddTransaction(transaction: transaction)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
 
    }
        
    
    func checkInput() -> Bool{
        var check = true
        if paymentPrice.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Failed to add transaction", message: "Price is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            check = false

            
        }
        else if paymentName.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Failed to add transaction", message: "Name is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            check = false

        }
        else if section.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Failed to add transaction", message: "Section is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            check = false

        }
        else if dateTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Failed to add transaction", message: "Date is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            check = false

        }
        else if section.text != "Housing" && section.text != "Food" && section.text != "Transportation" &&
            section.text != "Lifestyle" && section.text != "Debts" && section.text != "Miscellaneous" && section.text != "Income"{
            
            let alert = UIAlertController(title: "Failed to add transaction", message: "Please select a section that is listed ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            check = false
        }
        return check
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
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }

    func createTransaction() -> Transaction {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: dateTextField.text ?? "") ?? Date()
        let calendar = Calendar.current
        paymentPrice.text?.removeFirst()
        var priceString = String((paymentPrice.text?.dropFirst())!)
        priceString = priceString.replacingOccurrences(of: ",", with: "")
        let customDate = DateStruct(month: calendar.component(.month, from: date),
                                    day: calendar.component(.day, from: date),
                                    year: calendar.component(.year, from: date))

        if section.isEnabled == false {
            section.text = "Income"
        }



        var transaction = Transaction(vendorName: paymentName.text!, category: section.text!, description: "test", amount: (Double(priceString) ?? 0), date: customDate)

        if  let existingTransaction = existingPayment{
            existingTransaction.vendorName = paymentName.text!
            existingTransaction.amount = (Double(paymentPrice.text!) ?? 0 )
            existingTransaction.category = section.text!
            transaction = existingTransaction
            return transaction
        }
        else{

        return transaction
        }
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
