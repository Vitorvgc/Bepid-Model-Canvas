//
//  PostitType.swift
//  BepidModelCanvas
//
//  Created by Gustavo Gomes de Oliveira on 21/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//


import UIKit

class PostitType: UICollectionViewCell {
        
    @IBOutlet weak var textViewPostit: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var colorViews: [FocusableView]!
    @IBOutlet weak var label: UILabel!
    
    var isEditing = true
    
    override var canBecomeFocused: Bool {
        return !self.isEditing
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return self.isEditing ? [self.textField, self.colorViews[0], self.colorViews[1], self.colorViews[2]] : super.preferredFocusEnvironments
    }
    
    @IBAction func edit(_ sender: UITextField) {
        
        sender.text = self.textViewPostit.text
    }
    
    @IBAction func clear(_ sender: UITextField) {
        
        self.textViewPostit.text = sender.text
        sender.text = ""
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.textViewPostit.backgroundColor = UIColor(white: 1, alpha: 0)
        
        // Gesture recognizers
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        //self.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(gestureRecognizer:)))
        doubleTapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        //self.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        //self.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    func resizeOutlets() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let textFrame = CGRect(x: width * 0.03, y: height * 0.03, width: width * 0.94, height: height * 0.64)
        self.textViewPostit.frame = textFrame
        self.textField.frame = textFrame
        
        var xPosition = width * 0.03
        self.colorViews.forEach {
            $0.frame = CGRect(x: xPosition, y: height * 0.7, width: width / 10, height: width / 10)
            xPosition += $0.frame.width * 1.2
        }
        
        let viewFrame = self.colorViews[0].frame
        self.label.frame = CGRect(x: xPosition, y: viewFrame.minY, width: width - xPosition, height: viewFrame.height)
        
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.isEditing = true
        self.setNeedsFocusUpdate()
    }
    
    func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.textViewPostit.text = "Double tapped"
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        self.textViewPostit.text = "Long pressed"
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return (context.nextFocusedItem as! UIView).tag == self.tag
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
