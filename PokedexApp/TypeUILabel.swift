//
//  TypeUILabel.swift
//  PokedexApp
//
//  Created by Dara on 4/6/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class TypeUILabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.frame.size.width = 80
        self.frame.size.height = 21
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.baselineAdjustment = .alignCenters
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var text: String? {
        didSet {
            if let text = text {
                self.backgroundColor = UIColor.myColor.get(from: text)
            }
        }
    }
}
