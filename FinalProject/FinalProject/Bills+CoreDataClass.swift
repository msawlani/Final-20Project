//
//  Bills+CoreDataClass.swift
//  FinalProject
//
//  Created by Michael Sawlani on 6/6/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//
//

import UIKit
import CoreData


public class Bills: NSManagedObject {
    convenience init(name: String?, price: String?, section: String?) {
        self.init()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        
        self.init(entity: Bills.entity(), insertInto: context)
        self.name = name
        self.price = price
        self.section = section
    }

}
