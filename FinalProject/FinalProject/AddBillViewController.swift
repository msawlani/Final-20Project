//
//  AddBillViewController.swift
//  FinalProject
//
//  Created by Evelyn Lima on 5/10/19.
//  Copyright © 2018 Evelyn Lima. All rights reserved.
//

import Foundation
import UIKit

enum RepeatEnum: String {
    case None = "None"
    case OnTheDay = "On The Day"
    case OneDayBefore = "One Day Before"
    case TwoDaysBefore = "Two Days Before"
    case OneWeekBefore = "One Week Before"
}

class AddBillViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
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
        static let categories = ["Housing", "Food", "Transportation", "Lifestyle", "Debts", "Miscellaneous"]
        static let repeatCategories: [RepeatEnum] = [.None, .OnTheDay, .OneDayBefore, .TwoDaysBefore, .OneWeekBefore]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        installView()
        overrideBackButton()
        amountTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        doneButton.tintColor = .white
    }

    func overrideBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
    }

    @objc func backButtonAction() {


        if isFieldsEmpty() == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Are you sure?", message: "If you proceed, all the data on this page will be lost", preferredStyle: UIAlertController.Style.alert)

            let alertAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
                self?.navigationController?.popViewController(animated: true)
            }

            let goBackAction = UIAlertAction(title: "No", style: .default)

            alert.addAction(alertAction)
            alert.addAction(goBackAction)

            present(alert, animated: true)
        }
    }

    func isFieldsEmpty() -> Bool {

        var isEmpty = true

        if amountTextField.text?.isEmpty == false {
            isEmpty = false
        }

        if nameTextField.text?.isEmpty == false {
            isEmpty = false
        }

        if dateTextField.text?.isEmpty == false {
            isEmpty = false
        }

        if categoryTextField.text?.isEmpty == false {
            isEmpty = false
        }

        if repeatCategoryTextField.text?.isEmpty == false {
            isEmpty = false
        }

        return isEmpty
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
            nameTextField.text = bill.billName
            let amount = String(describing: (bill.amount * 10))
            let amountString = amount.CurrencyInputFormatting()
            amountTextField.text = amountString
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            dateTextField.text = formatter.string(from: bill.date.createDate())
            autoPaySwitch.isOn = bill.autoPay
            categoryTextField.text = bill.category
            repeatCategoryTextField.text = bill.paymentRepeat
        }
    }

    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.CurrencyInputFormatting() {
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

        guard let bill = createBill() else {
            return
        }

        guard let home = self.navigationController?.viewControllers.first as? SecondViewController else {
            return
        }

        if let indexPathRow = editIndexPathRow {
            home.billsContainer[indexPathRow] = bill
            mainUser.bills[indexPathRow] = bill
            mainUser.StoreInFirebase()
        }
        else {
            home.billsContainer.append(bill)
            _ = mainUser.AddBill(bill: bill)
        }
        self.navigationController?.popViewController(animated: true)
    }

    func createBill() -> Bill? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        guard let date = dateFormatter.date(from: dateTextField.text ?? "") else {
            assertionFailure("Error on date parsers")
            return nil
        }

        let calendar = Calendar.current
        let customDate = DateStruct(month: calendar.component(.month, from: date),
                                    day: calendar.component(.day, from: date),
                              year: calendar.component(.year, from: date))

        amountTextField.text?.removeFirst()
        amountTextField.text = amountTextField.text?.replacingOccurrences(of: ",", with: "")

       let uuid = UUID()


        let bill = Bill(billName: nameTextField.text ?? "",
                        description: "test", amount: Double(amountTextField.text!) ?? 0,
                        date: customDate,
                        autoPay: autoPaySwitch.isOn,
                        category: categoryTextField.text!,
                        paymentRepeat: repeatCategoryTextField.text!,
                        uuid: UUID())

         scheduleNotification(for: bill)

        return bill
    }

    func scheduleNotification(for bill: Bill) {

        guard let paymentRepeat = RepeatEnum(rawValue: bill.paymentRepeat) else {
            print("[ERROR] - Failing to Parse Repeat Type")
            assertionFailure()
            return
        }

        var notificationDate: Date?

        switch paymentRepeat {
        case .None:
            return
        case .OnTheDay:
            notificationDate = bill.date.date
            break
        case .OneDayBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: bill.date.date)
            break
        case .TwoDaysBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -2, to: bill.date.date)
            break
        case .OneWeekBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: bill.date.date)
            break
        }

        guard let date = notificationDate else {
            return
        }

        if isEditing == false {
            NotificationManager.shared.createNotification(for: date, billName: bill.billName, uuid: bill.uuid)
        } else if isEditing == true {
            NotificationManager.shared.editPendingNotification(for: date, billName: bill.billName, uuid: bill.uuid)
        }
    }

    func isNotificationDatePastDate(type: RepeatEnum, date: Date) -> Bool {
        var notificationDate: Date?

        switch type {
        case .None:
            return false
        case .OnTheDay:
            notificationDate = date
            break
        case .OneDayBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
            break
        case .TwoDaysBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -2, to: date)
            break
        case .OneWeekBefore:
            notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: date)
            break
        }

        guard let date = notificationDate else {
            return false
        }

        if date.timeIntervalSinceNow.sign == .minus {
            print("[WARNING] - Notication is past current date, skipping creation")
            return true
        }

        return false
    }

    func checkInputFields() -> Bool {
         let alert = UIAlertController()
        var check = true
        if amountTextField.text?.isEmpty ?? true {
            alert.title = "Amount is Empty"
            alert.message = "Please Fill the Amount to add a Bill"
            check = false
        }
        else if let amount = amountTextField.text {
            var amountFormatted: String = amount
            amountFormatted = amountFormatted.replacingOccurrences(of: ",", with: "")
            amountFormatted = amountFormatted.replacingOccurrences(of: "$", with: "")
            //amountFormatted = amount.replacingOccurrences(of: ".", with: "")
            if let value = Double(amountFormatted), value > 100000.00 {
                alert.title = "Amount is over limit"
                alert.message = "The limit is 100000.00, Please fill within the range"
                check = false
            }
        }
        else if nameTextField.text?.isEmpty ?? true{
            alert.title = "Name is Empty"
            alert.message = "Please Fill the Name to add a Bill"
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
            alert.title = "Reminder is not Selected"
            alert.message = "Please Select a Repeat Option to add a Bill"
            check = false
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateTextField.text ?? ""),
         let repeatCategory =  RepeatEnum(rawValue: repeatCategoryTextField.text ?? "None") {

            if isNotificationDatePastDate(type: repeatCategory, date: date) {
                alert.title = "Reminder is not Available"
                alert.message = "Please Select a Reminder Option that is not past date."
                check = false
            }
        }

        if check == false {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
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

        let donePickerButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneRepeatPicker))
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
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func doneCategoryPicker() {
        let row =  categoryPickerView.selectedRow(inComponent: 0)
        pickerView(categoryPickerView, didSelectRow: row, inComponent: 0)
        self.view.endEditing(true)
    }

    @objc func doneRepeatPicker() {
        let row =  repeatCategoryPickerView.selectedRow(inComponent: 0)
        pickerView(repeatCategoryPickerView, didSelectRow: row, inComponent: 0)
        self.view.endEditing(true)
    }

}

extension AddBillViewController: UITextFieldDelegate {


}

extension String {

    // formatting text for currency textField
    func CurrencyInputFormatting() -> String {

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
            return Constants.repeatCategories[row].rawValue
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
            return repeatCategoryTextField.text = Constants.repeatCategories[row].rawValue
        }
    }
}
