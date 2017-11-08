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
    let roundLabel = UILabel()
    
    /// The radius of the `roundLabel`. In most cases, its height is hightly prefered
    private var radius: CGFloat {
        return self.roundLabel.frame.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let rect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: rect)
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            superview.addSubview(roundLabel)
            configureRoundLabelConstraints()
        } else {
            roundLabel.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureRadius()
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            roundLabel.layer.borderColor = backgroundColor?.cgColor
        }
    }
    
    // TODO: - Implement the function to allow roundLabel resize by pass in a change in radius, dr.
//    /**
//     Use this to grow the `roundLabel` size. The passed in value will be use on both width and height.
//     - parameter dr: Pass in a negative number to shrink.
//     - parameter realignAfter: RIOLabel will make sure the round label is in the correct position
//     */
//    public func resizeRoundLabel(dr: CGFloat) {
//        roundLabelWidthConstraint.constant += dr
//        roundLabelHeighConstraint.constant += dr
//        configureRoundLabelRadius()
//    }

    private func configureView() {
        clipsToBounds = true
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        baselineAdjustment = .alignCenters
        textColor = UIColor.white
        backgroundColor = UIColor.black
        font = Constant.Font.gillSans
        configureRoundLabel()
    }
    
    private func configureRoundLabel() {
        roundLabel.clipsToBounds = true
        roundLabel.adjustsFontSizeToFitWidth = true
        roundLabel.textAlignment = .center
        roundLabel.baselineAdjustment = .alignCenters
        roundLabel.textColor = UIColor.black
        roundLabel.backgroundColor = UIColor.white
        roundLabel.layer.borderWidth = 3
        roundLabel.font = Constant.Font.gillSans
    }
    
    private func configureRoundLabelConstraints() {
        roundLabel.translatesAutoresizingMaskIntoConstraints = false
        roundLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        roundLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        roundLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2).isActive = true
        roundLabel.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 2).isActive = true
    }
    
    private func configureRadius() {
        layer.cornerRadius = frame.height / 2
        roundLabel.layer.cornerRadius = min(roundLabel.frame.width, roundLabel.frame.height) / 2
    }
}
