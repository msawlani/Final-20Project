//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData


var BillList = [NSManagedObject]()
var PriceList = [NSManagedObject]()
var BillListCell: BillListViewCell?


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var Table: UITableView!
    var nameTextField: UITextField?
    var priceTextField: UITextField?
    var updateName:UITextField?
    var updatePrice:UITextField?

    @IBOutlet weak var balanceText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Retrieve user data from Firebase and store it in user variable
        GetUser(userId: mainUser.userId, callback: { mainUser in
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
        
        let requestPrice = NSFetchRequest<NSFetchRequestResult>(entityName: "price")
        
        requestPrice.returnsObjectsAsFaults = false
}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bills")
        do{
            BillList = try context.fetch(fetchRequest)
            PriceList = try context.fetch(fetchRequest)

        }catch let err as NSError{
            print("failed to fetch items", err)
        }
    }
    
    //Gets the bills for the table view - Michael
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (BillList.count)
    }

    //populates the cells using the data - Michael
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BillListViewCell
        let bill = BillList[indexPath.row]
        let price = PriceList[indexPath.row]
        cell.Name.text = bill.value(forKey: "name") as? String
        cell.Price.text = price.value(forKey: "price") as? String
        return (cell)
    }
    
    //allows to swipe left on cells to edit and delete them - michael
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "Update", message: "Update a Bill", preferredStyle: .alert)

            alert.addTextField(configurationHandler: self.updateName)
            alert.addTextField(configurationHandler: self.updatePrice)


            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action) in
                
                guard let name = self.updateName?.text else {return}
                guard let price = self.updatePrice?.text else {return}
                

                if name.count == 0
                {
                    return
                }
                else{
                    self.updateBill(name, indexPath: indexPath)
                    self.Table.reloadRows(at: [indexPath], with: .automatic)
                }

                if price.count == 0{
                    return
                }
                else{
                    self.updatePriceBill(price, indexPath: indexPath)
                    self.Table.reloadRows(at: [indexPath], with: .automatic)

                }

            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))


            self.present(alert, animated: true)

        })

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "Delete", message: "Delete a Bill", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let context = appDelegate.persistentContainer.viewContext
                context.delete(BillList[indexPath.row])
                context.delete(PriceList[indexPath.row])
                do{
                    try context.save()
                    BillList.remove(at: indexPath.row)
                    PriceList.remove(at: indexPath.row)
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
        let alert = UIAlertController(title: "Add Bill to List", message: "Enter the Information Below to Add Bill", preferredStyle: .alert)

        alert.addTextField(configurationHandler: nameTextField)
        alert.addTextField(configurationHandler: priceTextField)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action) in
            guard let bill = self.nameTextField?.text else {return}
            guard let price = self.priceTextField?.text else {return}

            if bill.count == 0
            {
                return
            }


            if price.count == 0{
                return
            }

            self.addBill(bill)
            self.addPriceBill(price)

            print(bill)

            self.Table.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        self.present(alert, animated: true)
    }

    
    func nameTextField(textField: UITextField){
        nameTextField = textField
        nameTextField?.placeholder = "Bill Name..."

    }

    func priceTextField(textField: UITextField){
        priceTextField = textField
        priceTextField?.placeholder = "Bill Price..."
        
    }

    func updateName(textField: UITextField){
        updateName = textField
        updateName?.placeholder = "Change Bill Name..."
        

    }
    func updatePrice(textField: UITextField){
        updatePrice = textField
        updatePrice?.placeholder = "Change Bill Price..."
    }
    
    func updateBill(_ billName: String, indexPath: IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bills", in: context)!
        let bill = NSManagedObject(entity: entity, insertInto: context)
        bill.setValue(billName, forKey: "name")
        
        do{
            try context.save()
            BillList[indexPath.row] = bill
        }catch let err as NSError{
            print("Failed to Update Bill Name", err)
        }
    }
    
    func updatePriceBill(_ billPrice: String, indexPath: IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bills", in: context)!
        let price = NSManagedObject(entity: entity, insertInto: context)
        price.setValue(billPrice, forKey: "price")
        
        do{
            try context.save()
            PriceList[indexPath.row] = price
        }catch let err as NSError{
            print("Failed to Update Price of Bill", err)
        }
    }
    
    func addBill(_ billName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bills", in: context)!
        let bill = NSManagedObject(entity: entity, insertInto: context)
        bill.setValue(billName, forKey: "name")
        
        do{
            try context.save()
            BillList.append(bill)
        }catch let err as NSError{
            print("Failed to Update Bill Name", err)
        }
    }
    
    func addPriceBill(_ billPrice: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bills", in: context)!
        let price = NSManagedObject(entity: entity, insertInto: context)
        price.setValue(billPrice, forKey: "price")
        
        do{
            try context.save()
            PriceList.append(price)
        }catch let err as NSError{
            print("Failed to Update Price of Bill", err)
        }
    }
}
