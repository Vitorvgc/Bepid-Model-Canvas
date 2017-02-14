//
//  PostitCell.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 14/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class PostitCell: UICollectionViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var isEditing = false
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return self.isEditing ? [self.titleTextField] : super.preferredFocusEnvironments
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.titleTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        //self.titleTextField.sizeToFit()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.isEditing = true
        self.setNeedsFocusUpdate()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedItem === self {
            
            coordinator.addCoordinatedAnimations({
                
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.layer.shadowOpacity = 0.2
                self.layer.shadowOffset = CGSize(width: 0, height: 15)
                self.layer.shadowRadius = 15
                self.addMotionEffect(self.motionEffectGroup)
                
            }, completion: nil)
        }
        else if context.previouslyFocusedItem === self {
            
            coordinator.addCoordinatedAnimations({
                
                self.transform = CGAffineTransform.identity
                self.layer.shadowOpacity = 0
                self.removeMotionEffect(self.motionEffectGroup)
                
                self.isEditing = false
                
            }, completion: nil)
        }
    }
    
    lazy private var motionEffectGroup: UIMotionEffectGroup = {
        
        let horizontalAxisMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalAxisMotionEffect.minimumRelativeValue = -8.0
        horizontalAxisMotionEffect.maximumRelativeValue = 8.0
        
        let verticalAxisMoveEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalAxisMoveEffect.minimumRelativeValue = -8.0
        verticalAxisMoveEffect.maximumRelativeValue = 8.0
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalAxisMotionEffect, verticalAxisMoveEffect]
        
        return motionEffectGroup
    }()

}
