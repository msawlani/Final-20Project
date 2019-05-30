//
//  BillListViewCell.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/29/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

class BillListViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
