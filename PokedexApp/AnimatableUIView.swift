//
//  AnimatableUIView.swift
//  PokedexApp
//
//  Created by Dara on 6/17/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class AnimatableUIView: UIView {
    
    func addSubviews(_ views: ([TypeUILabel], [TypeUILabel])) {

        let (typeLabels, effectiveLabels) = views
        
        // Add constraints
        for i in 0 ..< typeLabels.count {
            
            let typeLabel = typeLabels[i]
            let effectiveLabel = effectiveLabels[i]
            
            self.addSubview(typeLabel)
            self.addSubview(effectiveLabel)
            
            let views: [String: Any] = ["typeLabel": typeLabel, "effectiveLabel": effectiveLabel]
            
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            effectiveLabel.translatesAutoresizingMaskIntoConstraints = false
            
            if typeLabel == typeLabels.first {
                let typeLabelVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[typeLabel]", options: [], metrics: nil, views: views)
                
                self.addConstraints(typeLabelVContraints)
                
            } else {
                let typeLabelVContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[prevTypeLabel]-8-[typeLabel]", options: [], metrics: nil, views: ["prevTypeLabel": typeLabels[i - 1], "typeLabel": typeLabels[i]])
                
                self.addConstraints(typeLabelVContraints)
            }
            
            
            // Pokemon's weaknesses effective width
            switch effectiveLabel.text! {
                
            case "1/4x":
                let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeLabel]-16-[effectiveLabel]", options: .alignAllCenterY, metrics: nil, views: views)
                
                let widthConstraint = NSLayoutConstraint.init(item: effectiveLabel, attribute: .width, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 2, constant: 0)
                
                self.addConstraints(hConstraints + [widthConstraint])
                
            case "1/2x":
                let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeLabel]-16-[effectiveLabel]", options: .alignAllCenterY, metrics: nil, views: views)
                
                let widthConstraint = NSLayoutConstraint.init(item: effectiveLabel, attribute: .width, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 4, constant: 0)
                
                self.addConstraints(hConstraints + [widthConstraint])
                
            case "2x":
                let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeLabel]-16-[effectiveLabel]", options: .alignAllCenterY, metrics: nil, views: views)
                
                let widthConstraint = NSLayoutConstraint.init(item: effectiveLabel, attribute: .width, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 8, constant: 0)
                
                self.addConstraints(hConstraints + [widthConstraint])
                
            case "4x":
                let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeLabel]-16-[effectiveLabel]-16-|", options: .alignAllCenterY, metrics: nil, views: views)
                
                self.addConstraints(hConstraints)
                
            case "0x":
                let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeLabel]-16-[effectiveLabel]", options: .alignAllCenterY, metrics: nil, views: views)
                
                let widthConstraint = NSLayoutConstraint.init(item: effectiveLabel, attribute: .width, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 2, constant: 0)
                
                self.addConstraints(hConstraints + [widthConstraint])
                
                effectiveLabel.textAlignment = .left
                effectiveLabel.font = UIFont(name: "\(effectiveLabel.font.fontName)-Bold", size: effectiveLabel.font.pointSize)
                effectiveLabel.textColor = typeLabel.backgroundColor
                effectiveLabel.backgroundColor = UIColor.clear
                
            default:()
            }
            
            let typeWidthConstraint = NSLayoutConstraint.init(item: typeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: typeLabel.frame.width)
            
            let typeHeightConstraint = NSLayoutConstraint.init(item: typeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: typeLabel.frame.height)
            
            let effecitveHeightConstraint = NSLayoutConstraint.init(item: effectiveLabel, attribute: .height, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 1, constant: 0)
            
            self.addConstraints([typeWidthConstraint, typeHeightConstraint, effecitveHeightConstraint])
        }
        
        if let selfLastSubview = typeLabels.last {
            let selfHeightConstraint = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: selfLastSubview, attribute: .bottom, multiplier: 1, constant: 16)
            
            self.addConstraint(selfHeightConstraint)
        }
    }
}



extension AnimatableUIView {
    
    convenience init(text: String) {
        
        self.init(frame: Constant.Constrain.frameUnderNavController)
        
        let textView: UITextView = {
            let textView = UITextView(frame: frame)
            textView.font = Constant.Font.appleSDGothicNeoRegular
            textView.isScrollEnabled = false
            textView.isEditable = false
            
            textView.text = text
            textView.sizeToFit()
            
            return textView
        }()
        
        self.addSubview(textView)
        self.frame.size.height = textView.contentSize.height + 16
        
        // add constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: UIView] = ["textView": textView]
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[textView]-16-|", options: [], metrics: nil, views: views)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textView]-|", options: [], metrics: nil, views: views)
        
        self.addConstraints(hConstraints + vConstraints)
    }

}
