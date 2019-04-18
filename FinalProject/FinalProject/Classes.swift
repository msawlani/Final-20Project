//
//  Classes.swift
//  FinalProject
//
//  Created by Justin Smith on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import Foundation
import Firebase

class User
{
    var username, password: String
    var accounts: [Account] = []
    var ref:DatabaseReference?
    
    init(username:String, password:String = "")
    {
        self.username = username
        self.password = password
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
                return true
            }
            i = i + 1
        }
        
        return false
    }
    
    func StoreInFirebase()
    {
        let ref = Database.database().reference()
        ref.child("users").child(self.username).child("username").setValue(self.username)
        ref.child("users").child(self.username).child("password").setValue(self.password)
        
        var i = 0
        
        while i < self.accounts.count
        {
            ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("accountName").setValue(self.accounts[i].name)
            ref.child("users").child(self.username).child("accounts").child(self.accounts[i].name).child("balance").setValue(self.accounts[i].balance)
            i = i + 1
        }
    }
}

class Account
{
    var name, bankName: String
    var balance: Float
    var transactions: [Transaction] = []
    
    init(name:String, bankName:String = "", balance:Float = 0.0)
    {
        self.name = name
        self.bankName = bankName
        self.balance = balance
    }
    
    func AddTransaction(transaction: Transaction)
    {
        self.transactions.append(transaction)
        self.balance = self.balance + transaction.amount
    }
    
    func RemoveTransaction(index: Int)
    {
        self.balance = self.balance - self.transactions[index].amount
        self.transactions.remove(at: index)
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

