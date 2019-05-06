//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

struct cellData {
    let cell: Int!
    let text: String!
    let imag: UIImage!
}
class FirstViewController: UITableViewController {

    
    var cellaDataArr = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sigedIn == false{
            performSegue(withIdentifier: "backToLogin", sender: self)
        }
        
    }
}

