//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData


var BillList: [Bills] = []
var Sections: [String] = []
var BillListCell: BillListViewCell?


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var Table: UITableView!

    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retrieve user data from Firebase and store it in user variable
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
        })
        //Justin

        //allows to get the data from core data - michael
        let requestName = NSFetchRequest<NSFetchRequestResult>(entityName: "name")

        requestName.returnsObjectsAsFaults = false

}

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.Table.reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Bills>(entityName: "Bills")
        do{
            BillList = try context.fetch(fetchRequest)


        }catch let err as NSError{
            print("failed to fetch items", err)
        }
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .cyan
//        return label
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections[section]
    }

    //Gets the bills for the table view - Michael
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BillList.count
    }



    //populates the cells using the data - Michael
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BillListViewCell
        let bill = BillList[indexPath.row]
        //let price = PriceList[indexPath.row]
        let price = bill.value(forKey: "price") as? String
        cell.Name.text = bill.value(forKey: "name") as? String
        cell.Price.text = price
        return (cell)
    }

    //allows to swipe left on cells to edit and delete them - michael
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            let bill = BillList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
            vc?.existingBill = bill
            self.navigationController?.pushViewController(vc!, animated: true)



        })

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "Delete", message: "Delete a Bill", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let context = appDelegate.persistentContainer.viewContext
                context.delete(BillList[indexPath.row])

                do{
                    try context.save()
                    BillList.remove(at: indexPath.row)
                    self.Table.reloadData()
                }catch{

                }

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
    }


}
