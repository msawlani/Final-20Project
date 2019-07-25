//
//  MiscViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 7/24/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

class MiscViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    var transactionArray = [Transactions]()
    var transactions = [Transaction]()
    
    @IBOutlet weak var Table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Table.delegate = self
        self.Table.dataSource = self
        self.Table.reloadData()
        
        transactionArray = [Transactions(isExpanded: true, sectionName: "Income", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Housing", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Food", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Transportation", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Lifestyle", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Debts", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Miscellaneous", TransactionList: [])
        ]
        
        navigationItem.title = "Miscellaneous"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: navigationItem.title!)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MiscViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        newBackButton.setTitleTextAttributes(systemFontAttributes, for: .normal)
        
        //mainUser.accounts[0].transactions[1]
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        var i = 0
        
        while i < mainUser.accounts[0].transactions.count
        {
            if mainUser.accounts[0].transactions[i].category == navigationItem.title{
                transactions.append(mainUser.accounts[0].transactions[i])
            }
            i+=1
        }
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TransactionListViewCell
        
        let transaction = transactions[indexPath.row]
        
        cell?.name.text = transaction.vendorName
        cell!.date.text = transaction.date.asString()
        
        var amountString = String(format: "$%.02f", transaction.amount)
        if (transaction.amount < 0)
        {
            var stringArray = Array(amountString)
            stringArray[0] = "-"
            stringArray[1] = "$"
            amountString = String(stringArray)
        }
        
        cell!.price.text = String(amountString)
        
        
        return cell!
    }
}
