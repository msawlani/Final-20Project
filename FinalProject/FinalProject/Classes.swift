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

class User: NSObject
{
    var username, password: String
    var numAccounts: Int
    var accounts: [Account] = []
    var ref:DatabaseReference?
    
    init(username:String, password:String = "")
    {
        self.username = username
        self.password = password
        self.numAccounts = 0
    }
    
    func AddAccount(account:Account) -> Bool
    {
        for n in self.accounts
        {
            if n.name == account.name
            {
                return false
            }
        }
        
        self.accounts.append(account)
        self.numAccounts+=1
        return true
    }
    
    func RemoveAcount(accountName: String) -> Bool
    {
        var i = 0
        
        while i < self.accounts.count
        {
            if self.accounts[i].name == accountName
            {
                self.accounts.remove(at: i)
                self.numAccounts-=1
                return true
            }
            i+=1
        }
        
        return false
    }
    
    func StoreInFirebase()
    {
        let ref = Database.database().reference()
        ref.child("users").child(self.username).child("username").setValue(self.username)
        ref.child("users").child(self.username).child("password").setValue(self.password)
        ref.child("users").child(self.username).child("numAccounts").setValue(self.accounts.count)
        
        var i = 0
        
        while i < self.accounts.count
        {
                ref.child("users").child(self.username).child("accounts").child("accountNum" + "\(i)").child("accountNum").setValue("account" + "\(i)")
                ref.child("users").child(self.username).child("accounts").child("accountNum" + "\(i)").child("accountName").setValue(self.accounts[i].name)
                ref.child("users").child(self.username).child("accounts").child("accountNum" + "\(i)").child("balance").setValue(self.accounts[i].balance)
                ref.child("users").child(self.username).child("accounts").child("accountNum" + "\(i)").child("bankName").setValue(self.accounts[i].bankName)
                ref.child("users").child(self.username).child("accounts").child("accountNum" + "\(i)").child("numTransactions").setValue(self.accounts[i].transactions.count)
            
            var j = 0
            
            while j < self.accounts[i].transactions.count
            {
                ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("transactions").child("transaction" + "\(j)").child("name").setValue(self.accounts[i].transactions[j].name)
                
                ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("transactions").child("transaction" + "\(j)").child("category").setValue(self.accounts[i].transactions[j].category)
                
                ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("transactions").child("transaction" + "\(j)").child("description").setValue(self.accounts[i].transactions[j].description)
                
                ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("transactions").child("transaction" + "\(j)").child("amount").setValue(self.accounts[i].transactions[j].amount)
                
                j+=1
            }
            i+=1
        }
    }
    
    func ReadFromFirebase()
    {
        self.ref = Database.database().reference()
        
        ref?.child("users").child("testUser2").observe(.value, with: { (snapshot) in

            do {
                self.numAccounts = snapshot.childSnapshot(forPath: "numAccounts").value! as! Int
            }
            catch {
                
            }
            
        })
//        var dataRead = false
//
//        ref?.child("users").child("testUser2")
//            .observeSingleEvent(of: .value, with: { (snapshot) in
//
//                let userDict = snapshot.value as! [String: Any]
//
//                self.numAccounts = userDict["numAccounts"] as! Int
//                self.password = userDict["password"] as! String
//                dataRead = true
//            })
//
//        if dataRead
//        {
//            var i = 0
//
//            while i < self.numAccounts
//            {
//                ref?.child("users").child("testUser2").child("accountNum" + "\(i)")
//                    .observeSingleEvent(of: .value, with: { (snapshot) in
//
//                        let userDict = snapshot.value as! [String: Any]
//
//                        let tempName = userDict["accountName"] as! String
//                        var tempAccount = Account(name: tempName)
//                        tempAccount.balance = userDict["balance"] as! Float
//                        tempAccount.bankName = userDict["bankName"] as! String
//                        tempAccount.numTransactions = userDict["numTransactions"] as! Int
//
//                        self.AddAccount(account: tempAccount)
//                    })
//
//                i+=1
//            }
//        }
    }
}

class Account
{
    var name, bankName, accountNum:String
    var numTransactions: Int
    var balance: Float
    var transactions: [Transaction] = []
    
    init(name:String = "", accountNumber: Int = 0, bankName:String = "", balance:Float = 0.0)
    {
        self.name = name
        self.accountNum = "account" + "\(accountNumber)"
        self.bankName = bankName
        self.balance = balance
        self.numTransactions = 0
    }
    
    func AddTransaction(transaction: Transaction)
    {
        self.transactions.append(transaction)
        self.balance = self.balance + transaction.amount
        self.numTransactions+=1
    }
    
    func RemoveTransaction(index: Int)
    {
        self.balance = self.balance - self.transactions[index].amount
        self.transactions.remove(at: index)
        self.numTransactions-=1
    }
}

class Transaction
{
    var name, category, description:String
    var amount: Float
    var date: Date
    
    init(name:String, category:String, description:String = "", amount:Float, date:Date)
    {
        self.name = name
        self.category = category
        self.description = description
        self.amount = amount
        self.date = date
    }
}

class Bill
{
    var name, account: String
    var amount: Float
    var recurring: Bool
    var date: Date

    init(name: String, amount: Float, account:String, recurring: Bool = false, date:Date)
    {
        self.name = name
        self.amount = amount
        self.account = account
        self.recurring = recurring
        self.date = date
    }
}

struct Date
{
    var month, day, year: Int
    
    init(month: Int, day: Int, year: Int)
    {
        self.month = month
        self.day = day
        self.year = year
    }
}

func GetUser(username: String) -> User {
    let user = User(username: username)
    //mRef = Database.database().reference()
    
//    Database.database().reference().child("users").child(username).observe(.childAdded, with: {(snapshot) in
//
//        print(snapshot)
//
//    }, withCancel: nil)
    
    Database.database().reference().child("users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
        //print(snapshot.value)
        if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = User(username: username)
            //user.setValuesForKeys(dictionary)
            //print(snapshot)
            //print(dictionary)
            //print(dictionary["accountNum0"]?["balance"])
            if let temp = dictionary["numAccounts"] as? Int{
                //print(temp)
                user.numAccounts = temp
            }
            if let temp = dictionary["password"] as? String{
                user.password = temp
            }
            //print(user)
//            user.numAccounts = snapshot.childSnapshot(forPath: "numAccounts").value! as! Int
//            user.password = snapshot.childSnapshot(forPath: "password").value! as! String
//
//            var i = 0
//            while i < user.numAccounts
//            {
//                var accountSnapshot = snapshot.childSnapshot(forPath:"accounts").childSnapshot(forPath: "accountNum" + "\(i)")
//                var account = Account()
//                account.name = accountSnapshot.childSnapshot(forPath: "accountName").value! as! String
//                account.balance = accountSnapshot.childSnapshot(forPath: "balance").value! as! Float
//                account.bankName = accountSnapshot.childSnapshot(forPath: "bankName").value! as! String
//                account.numTransactions = accountSnapshot.childSnapshot(forPath: "numTransactions").value! as! Int
//                user.AddAccount(account: account)
//            }
        }
    })
    //print(user.numAccounts)
    return user
}

