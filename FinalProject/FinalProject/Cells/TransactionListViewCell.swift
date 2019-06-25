//
//  TransactionListViewCell.swift
//  FinalProject
//
//  Created by Michael Sawlani on 6/12/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

class TransactionListViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
