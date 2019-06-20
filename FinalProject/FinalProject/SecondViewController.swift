//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var billsContainer: [Bill] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createNavigationButton()
        customizeView()

        var i = 0
        while i < mainUser.bills.count
        {
            billsContainer.append(mainUser.bills[i])
            i+=1
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    func createNavigationButton() {
        let barButtonItem = UIBarButtonItem(title: "+",
                                            style: .done,
                                            target: self,
                                            action: #selector(addTapped))
        self.navigationItem.setRightBarButton(barButtonItem, animated: true)

    }

    @objc func addTapped() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "addBillViewController") as? AddBillViewController else {
            return
        }

        //self.push(viewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }



    private func customizeView() {

        tableView.delegate = self as! UITableViewDelegate
        tableView.dataSource = self

        let billNib = UINib(nibName: BillTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(billNib, forCellReuseIdentifier: BillTableViewCell.reuseIdentifier)

        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func getCurrentMonth() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM - yyyy"

        let myString = formatter.string(from: today)
        return myString


    }


}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billsContainer.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BillTableViewCell.reuseIdentifier, for: indexPath) as? BillTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(bill: billsContainer[indexPath.row])
        return cell
    }


}

extension SecondViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            billsContainer.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedBill = billsContainer[indexPath.row]
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addBillController") as! AddBillViewController
//        nextViewController.editBill = selectedBill
//        nextViewController.editIndexPathRow = indexPath.row
//
//        self.navigationController?.pushViewController(nextViewController, animated: true)

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete =  deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "addBillViewController") as? AddBillViewController else {
                return
            }
            
            viewController.editBill = self.billsContainer[indexPath.row]
            viewController.editIndexPathRow = indexPath.row
            
            self.navigationController?.pushViewController(viewController, animated: true)

            completion(true)
        }

        action.backgroundColor = .gray
        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in


            self.billsContainer.remove(at: indexPath.row)
            mainUser.RemoveBill(index: indexPath.row)
            self.tableView.reloadData()
            completion(true)
        }

        return action
    }
   }
