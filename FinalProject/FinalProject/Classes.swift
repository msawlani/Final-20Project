//
//  Classes.swift
//  FinalProject
//
//  Created by Justin Smith on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import Foundation

class User
{
    var username, password: String
    var accounts: [Account] = []
    
    init(username:String, password:String = "")
    {
        self.username = username
        self.password = password
    }
    
    func AddAccount(account:Account)
    {
        self.accounts.append(account)
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
        balance = balance - transaction.amount
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

