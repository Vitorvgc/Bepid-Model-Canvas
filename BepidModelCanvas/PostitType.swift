//
//  PostitType.swift
//  BepidModelCanvas
//
//  Created by Gustavo Gomes de Oliveira on 21/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//


import UIKit

class PostitType: UICollectionViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var isEditing = false
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return self.isEditing ? [self.titleTextField] : super.preferredFocusEnvironments
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.titleTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        
        // Gesture recognizers
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(gestureRecognizer:)))
        doubleTapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    func resizeOutlets() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        self.titleTextField.frame = CGRect(x: width * 0.1, y: height * 0.1, width: width * 0.8, height: height * 0.8)
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.isEditing = true
        self.setNeedsFocusUpdate()
    }
    
    func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.titleTextField.text = "Double tapped"
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        self.titleTextField.text = "Long pressed"
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
        horizontalAxisMotionEffect.minimumRelativeValue = -6.0
        horizontalAxisMotionEffect.maximumRelativeValue = 6.0
        
        let verticalAxisMoveEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalAxisMoveEffect.minimumRelativeValue = -6.0
        verticalAxisMoveEffect.maximumRelativeValue = 6.0
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalAxisMotionEffect, verticalAxisMoveEffect]
        
        return motionEffectGroup
    }()
    
}
