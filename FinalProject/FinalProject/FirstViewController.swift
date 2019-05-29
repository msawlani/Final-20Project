//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import CoreData


var BillList = [String]()
var PriceList = [String]()


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var Table: UITableView!
    var nameTextField: UITextField?
    var priceTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (BillList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BillListViewCell
        let bill = BillList[indexPath.row]
        let price = PriceList[indexPath.row]
        cell.Name.text = bill
        cell.Price.text = price
        return (cell)
    }
    @IBAction func AddBill(_ sender: Any) {
        let alert = UIAlertController(title: "Add Bill to List", message: "Enter the Information Below to Add Bill", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nameTextField)
        alert.addTextField(configurationHandler: priceTextField)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action) in
            guard let bill = self.nameTextField?.text else {return}
            guard let price = self.priceTextField?.text else {return}
            
            BillList.append(bill)
            PriceList.append(price)
            
            self.Table.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func nameTextField(textField: UITextField){
        nameTextField = textField
        nameTextField?.placeholder = "name..."
    }
    
    func priceTextField(textField: UITextField){
        priceTextField = textField
        priceTextField?.placeholder = "price..."
    }
}

