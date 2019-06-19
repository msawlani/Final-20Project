//
//  CheckBox.swift
//  FinalProject
//
//  Created by Evelyn Lima on 5/11/19.
//  Copyright © 2018 Evelyn Lima. All rights reserved.
//

import Foundation

import UIKit

class CheckBox: UIButton {
    // Images
    let checkImage = UIImage(named: "Check")
    let uncheckedImage = UIImage(named: "Uncheck")
   
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkImage, for: UIControl.State.normal)
                self.tintColor = UIColor(named: "Food")
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
                self.tintColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        self.setImage(checkImage, for: UIControl.State.normal)
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
