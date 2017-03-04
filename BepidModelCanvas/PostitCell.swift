//
//  PostitCell.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 14/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

protocol PostitCellDelegate{
    func didLongPress(in cell: PostitCell);
}

class PostitCell: UICollectionViewCell {
    
    var delegate : PostitCellDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var onSelection: () -> Void = {}
    
    private var _postit = Postit()
    
    var postit: Postit {
        get {
            return _postit
        }
        set {
            _postit = newValue
            self.titleTextField.text = newValue.text
            self.backgroundColor = UIColor.PostitTheme.color(for: newValue.color)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.titleTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        
        // Gesture recognizers
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.addGestureRecognizer(tapGestureRecognizer)
        
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
        self.onSelection()
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        // go only when long press end, because if pick just the longpress will open two screens or more
        if gestureRecognizer.state == .ended {
            self.delegate?.didLongPress(in: self)
        }
    }
    
    //MARK: Focus engine
 
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
