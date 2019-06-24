//
//  Classes.swift
//  FinalProject
//
//  Created by Justin Smith on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import Foundation
import Firebase

var mRef:DatabaseReference?
var NUMDEFAULTCATS = 6

class User: NSObject
{
    var userId: String
    var email, firstName, lastName: String?
    var imageURL: URL?
    var numAccounts, numBills, numCategories: Int
    var accounts: [Account] = []
    var bills: [Bill] = []
    var categories: [String] = ["Housing", "Food", "Transportation", "Lifestyle", "Debts", "Miscellaneous"]
    var ref:DatabaseReference?

    init(userId:String, password:String = "")
    {
        self.userId = userId
        self.numAccounts = 0
        self.numBills = 0
        self.numCategories = 0
    }

    func PayBill(bill:Bill)
    {
        let transaction = Transaction()
        transaction.vendorName = bill.category
        transaction.category = bill.category
        //transaction.description = "Bill: " + bill.billName
        transaction.amount = -(bill.amount)
        self.accounts[0].AddTransaction(transaction: transaction)
    }

    func AddAccount(account:Account) -> Bool
    {
        for n in self.accounts
        {
            if n.accountName == account.accountName
            {
                return false
            }
        }
        account.accountNum = "accountNum" + "\(self.accounts.count)"
        self.accounts.append(account)
        self.numAccounts+=1
        StoreInFirebase()
        return true
    }

    func RemoveAcount(accountName: String) -> Bool
    {
        var i = 0

        while i < self.accounts.count
        {
            if self.accounts[i].accountName == accountName
            {
                self.accounts.remove(at: i)
                self.numAccounts-=1
                StoreInFirebase()
                return true
            }
            i+=1
        }

        return false
    }

    func AddBill(bill:Bill) -> Bool
    {
//        for n in self.bills
//        {
//            if n.billName == bill.billName
//            {
//                return false
//            }
//        }
        bill.billNum = "billNum" + "\(self.bills.count)"
        self.bills.append(bill)
        self.numBills+=1
        StoreInFirebase()
        return true
    }

    func RemoveBill(index: Int) -> Bool
    {
        self.bills.remove(at: index)
        self.numBills-=1
        StoreInFirebase()
        return true
    }

    func AddCategory(category: String) -> Bool
    {
        _ = 0

        for n in self.categories
        {
            if n == category
            {
                return false
            }
        }
        categories.append(category)
        self.numCategories+=1
        StoreInFirebase()
        return true
    }

    func StoreInFirebase()
    {
        let ref = Database.database().reference()
        ref.child("users").child(self.userId).removeValue()
        ref.child("users").child(self.userId).child("userId").setValue(self.userId)
        ref.child("users").child(self.userId).child("numAccounts").setValue(self.accounts.count)
        ref.child("users").child(self.userId).child("numBills").setValue(self.bills.count)
        ref.child("users").child(self.userId).child("numCategories").setValue(self.categories.count - NUMDEFAULTCATS)
        ref.child("users").child(self.userId).child("email").setValue(self.email)

        var i = 0

        while i < self.accounts.count
        {
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("accountNum").setValue("accountNum" + "\(i)")
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("accountName").setValue(self.accounts[i].accountName)
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("balance").setValue(self.accounts[i].balance)
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("bankName").setValue(self.accounts[i].bankName)
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("numTransactions").setValue(self.accounts[i].transactions.count)
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("totalIncome").setValue(self.accounts[i].totalIncome)
            ref.child("users").child(self.userId).child("accounts").child("accountNum" + "\(i)").child("totalExpenses").setValue(self.accounts[i].totalExpenses)


            var j = 0

            while j < self.accounts[i].transactions.count
            {
                ref.child("users").child(self.userId).child("accounts").child(self.accounts[i].accountNum).child("transactions").child("transactionNum" + "\(j)").child("vendorName").setValue(self.accounts[i].transactions[j].vendorName)

                ref.child("users").child(self.userId).child("accounts").child(self.accounts[i].accountNum).child("transactions").child("transactionNum" + "\(j)").child("category").setValue(self.accounts[i].transactions[j].category)

                ref.child("users").child(self.userId).child("accounts").child(self.accounts[i].accountNum).child("transactions").child("transactionNum" + "\(j)").child("description").setValue(self.accounts[i].transactions[j].description)

                ref.child("users").child(self.userId).child("accounts").child(self.accounts[i].accountNum).child("transactions").child("transactionNum" + "\(j)").child("amount").setValue(self.accounts[i].transactions[j].amount)


                let date = self.accounts[i].transactions[j].date
                let dateString = "\(date.month)" + "/" + "\(date.day)" + "/" + "\(date.year)"
                ref.child("users").child(self.userId).child("accounts").child(self.accounts[i].accountNum).child("transactions").child("transactionNum" + "\(j)").child("date").setValue(dateString)

                j+=1
            }
            i+=1
        }

        i=0
        while i < self.bills.count{
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("billNum").setValue("billNum" + "\(i)")
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("billName").setValue(self.bills[i].billName)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("description").setValue(self.bills[i].description)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("accountName").setValue(self.bills[i].accountName)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("amount").setValue(self.bills[i].amount)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("category").setValue(self.bills[i].category)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("recurring").setValue(self.bills[i].recurring)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("monthly").setValue(self.bills[i].monthly)
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("yearly").setValue(self.bills[i].yearly)

            let date = self.bills[i].date
            let dateString = "\(date.month)" + "/" + "\(date.day)" + "/" + "\(date.year)"
            ref.child("users").child(self.userId).child("bills").child("billNum" + "\(i)").child("date").setValue(dateString)
            i+=1
        }

        i=NUMDEFAULTCATS
        while i < (self.categories.count)
        {
            ref.child("users").child(self.userId).child("categories").child("categoryNum" + "\(i-NUMDEFAULTCATS)").setValue(categories[i])
            i+=1
        }
    }
}

class Account
{
    var accountName, bankName, accountNum: String
    var numTransactions: Int
    var balance, totalIncome,  totalExpenses: Double
    var transactions: [Transaction] = []

    init(name:String = "", bankName:String = "", balance:Double = 0.0)
    {
        self.accountName = name
        self.bankName = bankName
        self.balance = balance
        self.totalIncome = 0
        self.totalExpenses = 0
        self.numTransactions = 0
        self.accountNum = ""
    }

    func AddTransaction(transaction: Transaction)
    {
        self.transactions.append(transaction)
        self.balance = self.balance + transaction.amount
        self.numTransactions+=1
        
        if(transaction.amount > 0)
        {
            self.totalIncome += transaction.amount
        }
        else if(transaction.amount < 0)
        {
            self.totalExpenses += transaction.amount
        }
        
        mainUser.StoreInFirebase()
    }

    func RemoveTransaction(index: Int)
    {
        if(self.transactions[index].amount > 0)
        {
            self.totalIncome -= self.transactions[index].amount
        }
        else if(self.transactions[index].amount < 0)
        {
            self.totalExpenses -= self.transactions[index].amount
        }
        
        self.balance = self.balance - self.transactions[index].amount
        self.transactions.remove(at: index)
        self.numTransactions-=1
        
        mainUser.StoreInFirebase()
    }
    
    func getCategoryTotal(categoryNum: Int) -> Double
    {
        var total = 0.0
        var i = 0
        
        while i < transactions.count
        {
            if transactions[i].category == mainUser.categories[categoryNum]
            {
                total+=transactions[i].amount
            }
            i+=1
        }
        
        return -(total)
    }
}

class Transaction
{
    var vendorName, category, description, transactionNum:String
    var amount: Double
    var date: DateStruct

    init(vendorName:String = "", category:String = "", description:String = "", amount:Double = 0.0, date: DateStruct = DateStruct())
    {
        self.vendorName = vendorName
        self.category = category
        self.description = description
        self.amount = amount
        self.transactionNum = ""
        self.date = date
    }
}

class Bill
{
    var billName, description, accountName, billNum: String
    var amount: Double
    var recurring, monthly, yearly: Bool
    var date: DateStruct
    var autoPay: Bool
    var category: String
    var paymentRepeat: String

    init(billName: String = "", description: String = "", amount: Double = 0.0, accountName:String = "",
         recurring: Bool = false, monthly: Bool = false, yearly: Bool = false,
         date:DateStruct = DateStruct(), autoPay: Bool, category:String, paymentRepeat: String  )
    {
        self.billName = billName
        self.description = description
        self.amount = amount
        self.accountName = accountName
        self.recurring = recurring
        self.date = date
        self.monthly = monthly
        self.yearly = yearly
        self.billNum = ""
        self.autoPay = autoPay
        self.category = category
        self.paymentRepeat = paymentRepeat
    }

    func setDate(date: DateStruct)
    {
        self.date = date
    }


}


struct DateStruct
{
    var month, day, year: Int
    var date: Date

    init(month: Int, day: Int, year: Int)
    {
        self.month = month
        self.day = day
        self.year = year
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        dateComponents.day = self.day
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        self.date = userCalendar.date(from: dateComponents)!
    }
    init()
    {
        self.date = Date()
        let dateString = Date().asString(style: .short)
        let dateArr = dateString.components(separatedBy: "/")
        self.month = Int(dateArr[0]) ?? 0
        self.day = Int(dateArr[1]) ?? 0
        self.year = Int(dateArr[2]) ?? 0
    }
    func createDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime ?? Date()
    }
    func asString() -> String
    {
        return "\(self.month)" + "/" + "\(self.day)" + "/" + "\(self.year)"
    }
}

func GetUser(userId: String, callback: @escaping ((_ data:User) -> Void)) {
    Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in

        if snapshot.hasChild(userId)
        {
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let dictionary = dictionary[userId] as? [String: AnyObject] {
                    var result: Bool
                    let tempUser = User(userId: userId)

                    if let temp = dictionary["numAccounts"] as? Int{
                        tempUser.numAccounts = temp
                    }
                    if let temp = dictionary["numBills"] as? Int{
                        tempUser.numBills = temp
                    }
                    if let temp = dictionary["numCategories"] as? Int{
                        tempUser.numCategories = temp
                    }

                    var i = 0
                    while i < tempUser.numAccounts
                    {
                        if let temp = dictionary["accounts"]?["accountNum" + "\(i)"] as? [String: AnyObject] {
                            var accountDict = temp

                            let account = Account()
                            account.accountNum = "account" + "\(i)"
                            if let temp = accountDict["accountName"] as? String {
                                account.accountName = temp
                            }
                            if let temp = accountDict["balance"] as? Double{
                                account.balance = temp
                            }
                            if let temp = accountDict["bankName"] as? String{
                                account.bankName = temp
                            }
                            if let temp = accountDict["numTransactions"] as? Int{
                                account.numTransactions = temp
                            }
                            if let temp = accountDict["totalIncome"] as? Double{
                                account.totalIncome = temp
                            }
                            if let temp = accountDict["totalExpenses"] as? Double{
                                account.totalExpenses = temp
                            }

                            var j = 0
                            while j < account.numTransactions
                            {
                                if let temp = accountDict["transactions"]?["transactionNum" + "\(j)"] as? [String: AnyObject] {
                                    var transactionDict = temp
                                    let transaction = Transaction(date:DateStruct(month:0,day:0,year:0))
                                    transaction.transactionNum = "transaction" + "\(j)"
                                    if let temp = transactionDict["vendorName"] as? String{
                                        transaction.vendorName = temp
                                    }
                                    if let temp = transactionDict["category"] as? String{
                                        transaction.category = temp
                                    }
                                    if let temp = transactionDict["description"] as? String{
                                        transaction.description = temp
                                    }
                                    if let temp = transactionDict["amount"] as? Double{
                                        transaction.amount = temp
                                    }
                                    if let temp = transactionDict["date"] as? String{
                                        let dateArr = temp.components(separatedBy: "/")
                                        let date = DateStruct(month:Int(dateArr[0]) ?? 0, day:Int(dateArr[1]) ?? 0, year:Int(dateArr[2]) ?? 0)
                                        transaction.date = date
                                    }
                                    account.transactions.append(transaction)
                                }
                                j+=1
                            }

                            tempUser.numAccounts-=1
                            result = tempUser.AddAccount(account: account)
                        }

                        i+=1
                    }

                    i = 0

                    while i < tempUser.numBills
                    {
                        if let temp = dictionary["bills"]?["billNum" + "\(i)"] as? [String: AnyObject] {
                            var billDict = temp

                            let bill = Bill(autoPay: false, category: "", paymentRepeat: "")
                            bill.billNum = "bill" + "\(i)"

                            if let temp = billDict["billName"] as? String {
                                bill.billName = temp
                            }
                            if let temp = billDict["description"] as? String {
                                bill.description = temp
                            }
                            if let temp = billDict["accountName"] as? String {
                                bill.accountName = temp
                            }
                            if let temp = billDict["amount"] as? Double {
                                bill.amount = temp
                            }
                            if let temp = billDict["category"] as? String {
                                bill.category = temp
                            }
                            if let temp = billDict["recurring"] as? Bool {
                                bill.recurring = temp
                            }
                            if let temp = billDict["monthly"] as? Bool {
                                bill.monthly = temp
                            }
                            if let temp = billDict["yearly"] as? Bool {
                                bill.yearly = temp
                            }
                            if let temp = billDict["date"] as? String {
                                let dateArr = temp.components(separatedBy: "/")
                                let date = DateStruct(month:Int(dateArr[0]) ?? 0, day:Int(dateArr[1]) ?? 0, year:Int(dateArr[2]) ?? 0)
                                bill.date = date
                            }

                            tempUser.numBills-=1
                            result = tempUser.AddBill(bill: bill)
                        }
                        i+=1
                    }

                    i = 0
                    while i < tempUser.numCategories
                    {
                        if let temp = dictionary["categories"]?["categoryNum" + "\(i)"] as? String {
                            tempUser.numCategories-=1
                            result = tempUser.AddCategory(category: temp)
                        }
                        i+=1
                    }

                    callback(tempUser)
                }
            }
        }
        else {
            let tempUser = User(userId: userId)
            let tempAccount = Account(name: "Main Account")
            tempUser.AddAccount(account: tempAccount)
            tempUser.StoreInFirebase()
            callback(tempUser)
        }
    })
}

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
