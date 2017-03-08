//
//  CanvasModelsCollectionViewCell.swift
//  telainicialtvos
//
//  Created by Renata Faria on 16/02/17.
//  Copyright © 2017 Renata Faria. All rights reserved.
//

import UIKit

class CanvasModelsCollectionViewCell: UICollectionViewCell {
    var onSelection: () -> Void = {}
    
    @IBOutlet weak var CanvaImage: UIImageView!
    @IBOutlet weak var CanvaTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.layer.cornerRadius = 15
        self.clipsToBounds = true
       // self.backgroundColor = .white
       // self.backgroundColor =  UIColor(patternImage: #imageLiteral(resourceName: "pikachu"))

        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
//        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
//        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func resizeOutlets() {
        
        _ = self.frame.size.width
        _ = self.frame.size.height

    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.onSelection()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedItem === self {
            
            coordinator.addCoordinatedAnimations({
                
                self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                
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
