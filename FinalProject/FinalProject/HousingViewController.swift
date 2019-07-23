//
//  HousingViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 7/23/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

var TransactionListCell: TransactionListViewCell?
struct Transactions {
    var isExpanded: Bool
    var sectionName: String!
    var TransactionList: [Transaction] = []
}

class HousingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionArray = [Transactions(isExpanded: true, sectionName: "Income", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Housing", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Food", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Transportation", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Lifestyle", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Debts", TransactionList: []),
                            Transactions(isExpanded: true, sectionName: "Miscellaneous", TransactionList: [])
        ]
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

}
