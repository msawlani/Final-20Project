//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData



//var testList: [String] = ["test"]
var TransactionListCell: TransactionListViewCell?


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {




    struct Transactions {
        var sectionName: String!
        var TransactionList: [Transaction] = []
    }

    var transactionArray = [Transactions]()


    @IBOutlet weak var Table: UITableView!

    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retrieve user data from Firebase and store it in user variable
        self.Table.delegate = self
        self.Table.dataSource = self
        self.Table.reloadData()


        transactionArray = [Transactions(sectionName: "Income", TransactionList: []),
                            Transactions(sectionName: "Housing", TransactionList: []),
                            Transactions(sectionName: "Food", TransactionList: []),
                            Transactions(sectionName: "Transportation", TransactionList: []),
                            Transactions(sectionName: "Lifestyle", TransactionList: []),
                            Transactions(sectionName: "Debts", TransactionList: []),
                            Transactions(sectionName: "Miscellaneous", TransactionList: [])
                            ]
        
        
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.Table.reloadData()
        addButton.tintColor = UIColor.white
        

        GetUser(userId: mainUser.userId, callback: { tempUser in
            mainUser = tempUser
            if signedInWithGoogle
            {
                mainUser.email = googleUser.profile.email
                mainUser.imageURL = googleUser.profile.imageURL(withDimension: 112)
                mainUser.firstName = googleUser.profile.givenName
                mainUser.lastName = googleUser.profile.familyName

                // Start background thread so that image loading does not make app unresponsive
                DispatchQueue.global(qos: .userInitiated).async {

                    let imageData:NSData = NSData(contentsOf: mainUser.imageURL!)!

                    // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData as Data)
                        self.imageView.image = image
                        //self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
                        //self.view.addSubview(self.imageView)
                    }
                }
            }
            else{
                mainUser.email = userEmail
            }
            mainUser.StoreInFirebase()

            var balanceString = String(format: "$%.02f", mainUser.accounts[0].balance)
            if (mainUser.accounts[0].balance < 0)
            {
                var stringArray = Array(balanceString)
                stringArray[0] = "-"
                stringArray[1] = "$"
                balanceString = String(stringArray)
            }

            self.balanceText.text = String(balanceString)
            self.usernameText.text = mainUser.email



            var i = 0
            var j = 0
            while i < NUMDEFAULTCATS{
                self.transactionArray[i].TransactionList.removeAll()
                i+=1

            }
            i = 0

            while i < mainUser.accounts[0].transactions.count
            {
                j = 0
                while j < NUMDEFAULTCATS{
                    if mainUser.accounts[0].transactions[i].category == self.transactionArray[j].sectionName{
                        self.transactionArray[j].TransactionList.append(mainUser.accounts[0].transactions[i])
                    }
                    j+=1
                }
                i+=1
            }
            self.Table.reloadData()
        })
        //Justin


}

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .cyan
//        return label
//    }

    //Gets the bills for the table view - Michael
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray[section].TransactionList.count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            if section == 0{
            header.backgroundView?.backgroundColor = UIColor.green
            }else if section == 1{
                header.backgroundView?.backgroundColor = UIColor(red:0.45, green:0.73, blue:1.00, alpha:1.0)
            }else if section == 2{
                header.backgroundView?.backgroundColor = UIColor(red:0.33, green:0.94, blue:0.77, alpha:1.0)
            }else if section == 3{
                header.backgroundView?.backgroundColor = UIColor(red:0.63, green:0.50, blue:0.23, alpha:1.0)
            }else if section == 4{
                header.backgroundView?.backgroundColor = UIColor(red:0.99, green:0.47, blue:0.66, alpha:1.0)
            }else if section == 5{
                header.backgroundView?.backgroundColor = UIColor(red:0.84, green:0.19, blue:0.19, alpha:1.0)
            }else if section == 6{
                header.backgroundView?.backgroundColor = UIColor(red:0.70, green:0.75, blue:0.76, alpha:1.0)
            }
            
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section < transactionArray.count {

            
            
            return transactionArray[section].sectionName

        }
        return nil

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return transactionArray.count
    }

    //populates the cells using the data - Michael
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TransactionListViewCell

        let transaction = transactionArray[indexPath.section].TransactionList[indexPath.row]
        //let test = testList[indexPath.row]


        cell!.name.text = transaction.vendorName
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


    //allows to swipe left on cells to edit and delete them - michael
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in

            let transaction = self.transactionArray[indexPath.section].TransactionList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "addViewController") as? AddViewController
            vc?.existingPayment = transaction
            vc?.index = indexPath.row
            vc?.indexSection = indexPath.section
            self.navigationController?.pushViewController(vc!, animated: true)



        })


        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "Delete", message: "Delete a Transaction?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))


            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
//                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//                let context = appDelegate.persistentContainer.viewContext

                var indexString = self.transactionArray[indexPath.section].TransactionList[indexPath.row].transactionNum
                indexString = String(indexString.dropFirst(11))
                let index = Int(indexString)
                mainUser.accounts[0].RemoveTransaction(index: index!)


                self.transactionArray[indexPath.section].TransactionList.remove(at: indexPath.row)
                self.Table.reloadData()
                
                self.viewWillAppear(true)
                self.viewDidLoad()
            }))


            self.present(alert, animated: true)
        })


        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .blue
        return[deleteAction, editAction]
    }

//Function for add button to add bills to list - michael
    @IBAction func AddBill(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "addViewController") as? AddViewController else {
            return
        }


        //self.push(viewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
