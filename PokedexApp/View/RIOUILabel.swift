//
//  RIOUILabel.swift
//  CustomUIProject
//
//  Created by Dara on 4/23/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class RIOUILabel: UILabel {
    
    /// The round label at the right size of `self`, the main label.
    var roundLabel: RoundUILabel!
    
    /// The radius of the `roundLabel`. In most cases, its height is hightly prefered
    private var radius: CGFloat {
        return self.roundLabel.frame.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //configure self
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.baselineAdjustment = .alignCenters
        self.textColor = UIColor.white
        self.backgroundColor = UIColor.black
        self.font = Constant.Font.gillSans
        
        //configure roundLabel
        self.roundLabel.layer.cornerRadius = radius / 2
        self.roundLabel.clipsToBounds = true
        self.roundLabel.adjustsFontSizeToFitWidth = true
        self.roundLabel.textAlignment = .center
        self.roundLabel.baselineAdjustment = .alignCenters
        self.roundLabel.textColor = UIColor.black
        self.roundLabel.backgroundColor = UIColor.white
        self.roundLabel.layer.borderWidth = 3
        self.roundLabel.font = Constant.Font.gillSans
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.superview?.addSubview(self.roundLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet {
            if self.roundLabel == nil {
                let radius = self.frame.height + 12 //+12 to make sure initially roundLabel is larger than main label
                let x = self.frame.origin.x + (self.frame.width - radius)
                let y = self.frame.origin.y - (radius - self.frame.height) / 2
                self.roundLabel = RoundUILabel(frame: CGRect(x: x, y: y, width: radius, height: radius))
            } else {
                self.roundLabel.frame.origin.x = roundLabelOriginX
                self.roundLabel.frame.origin.y = roundLabelOriginY
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            self.roundLabel.layer.borderColor = self.backgroundColor?.cgColor
        }
    }
    
    override func drawText(in rect: CGRect) {
        let x: CGFloat = 5
        super.drawText(in: CGRect(x: x, y: 0, width: rect.width - x * 3 - radius / 2, height: rect.height))
    }
}

extension RIOUILabel {
    
    /// Check if the `roundLabel` is vertically centered with the main label, `self`.
    var isRoundLabelVerticallyCentered: Bool {
        return roundLabel.frame.origin.y == roundLabelOriginY
    }
    
    /// Check if the `roundLabel` is at the end, its defaulf x position, of the main label.
    var isRoundLabelHorizontallyEnd: Bool {
        return roundLabel.frame.origin.x == roundLabelOriginX
    }
    
    /// The default x position where the `roundLabel` should be
    var roundLabelOriginX: CGFloat {
        return self.frame.origin.x + (self.frame.width - self.roundLabel.frame.width)
    }
    
    /// The default y position where the `roundLabel` should be
    var roundLabelOriginY: CGFloat {
        return self.frame.origin.y - (self.roundLabel.frame.height - self.frame.height) / 2
    }
    
    /**
     Use this to grow the `roundLabel` size. The passed in value will be use on both width and height.
     - parameter dr: Pass in a negative number to shrink.
     - parameter realignAfter: RIOLabel will make sure the round label is in the correct position
     */
    func resizeRoundLabel(dr: CGFloat, realignAfter: Bool = false) {
        
        self.roundLabel.frame.size.width += dr
        self.roundLabel.frame.size.height += dr
        if self.roundLabel.frame.height > self.roundLabel.frame.width {
            self.roundLabel.layer.cornerRadius = self.roundLabel.frame.width / 2
        } else {
            self.roundLabel.layer.cornerRadius = self.roundLabel.frame.height / 2
        }
        
        if realignAfter {
            realignIfNotVerticallyCentered()
        }
    }
    
    /**
     Check and align if the `roundLabel` is not vertically centered at the end of the main label, its default position. This behavior usually happens when directly resize `roundLabel` using `roundLabel.frame.size`.
     - note: To avoid miss position, use `growRoundLabelSize(by: CGFloat)` to increase or decrease its size.
     */
    func realignIfNotVerticallyCentered() {
        
        if !isRoundLabelVerticallyCentered || !isRoundLabelHorizontallyEnd {
            roundLabel.frame.origin.x = roundLabelOriginX
            roundLabel.frame.origin.y = roundLabelOriginY
        }
    }
}

// MARK: - RoundUILabel

class RoundUILabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let x: CGFloat = 5
        super.drawText(in: CGRect(x: x, y: 0, width: rect.width - x * 2, height: rect.height))
    }
}

