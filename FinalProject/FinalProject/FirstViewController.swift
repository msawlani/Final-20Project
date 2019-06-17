//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData


var Sections: [String] = []

//var testList: [String] = ["test"]
var TransactionListCell: TransactionListViewCell?


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var TransactionList: [Transaction] = []
    var MainSections: [String] = ["Food", "Housing", "Life Style", "Miscellaneous", "Transportation"]

    @IBOutlet weak var Table: UITableView!

    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retrieve user data from Firebase and store it in user variable
        self.Table.delegate = self
        self.Table.dataSource = self
        self.Table.reloadData()
        
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
            self.balanceText.text = String(format: "$%.02f", mainUser.accounts[0].balance)
            self.usernameText.text = mainUser.email

            
            var i = 0
            while i < mainUser.accounts[0].transactions.count
            {
                self.TransactionList.append(mainUser.accounts[0].transactions[i])
                i+=1
            }
        })
        //Justin
    
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.Table.reloadData()

    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .cyan
//        return label
//    }

    //Gets the bills for the table view - Michael
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MainSections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainSections.count
    }

    //populates the cells using the data - Michael
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TransactionListViewCell
        
        let transaction = TransactionList[indexPath.row]
        //let test = testList[indexPath.row]
        cell!.name.text = transaction.vendorName
        cell!.price.text = "$\(transaction.amount)" as String

        return cell!
    }

    //allows to swipe left on cells to edit and delete them - michael
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            
            let transaction = self.TransactionList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "addViewController") as? AddViewController
            vc?.existingPayment = transaction
            vc?.index = indexPath.row
            self.navigationController?.pushViewController(vc!, animated: true)



        })
        

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "Delete", message: "Delete a Bill", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
//                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//                let context = appDelegate.persistentContainer.viewContext
                mainUser.accounts[0].RemoveTransaction(index: indexPath.row)


                self.TransactionList.remove(at: indexPath.row)
                self.Table.reloadData()

            }))

            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

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
    
    @IBAction func DeleteAll(_ sender: Any) {
//        let alert = UIAlertController(title: "Delete All Transactions?", message: "Press Yes to delete all or press no to cancel", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {(action) in
//            let alert2 = UIAlertController(title: "You Really Sure?", message: "Yes or No?", preferredStyle: .alert)
//            alert2.addAction(UIAlertAction(title: "YES", style: .default, handler: {(action ) in
//                self.TransactionList.remove(at: )
//                mainUser.accounts[0].transactions.removeAll()
//            }))
//
//            alert2.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
//            self.present(alert2, animated: true)
//        }))
//        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
//
//        self.present(alert, animated: true)
//
        }
    

}
