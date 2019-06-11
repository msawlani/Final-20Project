//
//  Bills+CoreDataProperties.swift
//  FinalProject
//
//  Created by Michael Sawlani on 6/6/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//
//

import Foundation
import CoreData


extension Bills {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bills> {
        return NSFetchRequest<Bills>(entityName: "Bills")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var section: String?

}
