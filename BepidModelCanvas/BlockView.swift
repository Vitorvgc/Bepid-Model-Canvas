//
//  BlockView.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 16/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class BlockView: UIView {

    var collectionView: UICollectionView!
    var isEditing = false
    
    override var canBecomeFocused: Bool {
        return !isEditing
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return self.isEditing ? [self.collectionView] : super.preferredFocusEnvironments
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.isEditing = true
        self.collectionView.reloadData()
        self.setNeedsFocusUpdate()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
      
        if context.nextFocusedItem === self {
            
            coordinator.addCoordinatedAnimations({
                
                self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
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
                
            }, completion: nil)
        }
        else if (context.nextFocusedItem != nil && context.nextFocusedItem!.isKind(of: BlockView.self)) {
            self.isEditing = false
            self.collectionView.reloadData()
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
