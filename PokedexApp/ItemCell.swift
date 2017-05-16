//
//  ItemCell.swift
//  PokedexApp
//
//  Created by Dara on 5/1/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var rhsLbl: UILabel!
    @IBOutlet weak var lhsLbl: UILabel!
    
    func configureCell(item: Item) {
        
        self.rhsLbl.text = item.name
        self.lhsLbl.text = item.category
    }
    
    func configureCell(tm: Item) {
        
        self.rhsLbl.text = tm.name
        self.lhsLbl.isHidden = true
    }
    
    func configureCell(berry: Item) {
        
        self.rhsLbl.text = berry.name
        self.lhsLbl.isHidden = true
    }
}
