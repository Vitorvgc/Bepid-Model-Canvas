//
//  PostitType.swift
//  BepidModelCanvas
//
//  Created by Gustavo Gomes de Oliveira on 21/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//


import UIKit

protocol PostitTypeDelegate {
    
    func didPressMenu(in cell: PostitType)
    func didPressPlayPause(in cell: PostitType)
}

class PostitType: UICollectionViewCell {
    
    @IBOutlet weak private var textViewPostit: UITextView!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet private var colorViews: [FocusableView]!
    @IBOutlet weak private var label: UILabel!
    
    var delegate: PostitTypeDelegate?
    
    private var isEditing = true
    private var _postit: CWPostit?
    
    var postit: CWPostit? {
        get {
            return _postit
        }
        set {
            _postit = newValue
            self.reset()
        }
    }
    
    var text: String {
        return self.textViewPostit.text
    }
    
    var selectedColor: UIColor {
        return self.textViewPostit.backgroundColor!
    }
    
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
        self.setColorViewsTapGestures()
        self.reset()
        // Gesture recognizers
        
        let menuTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMenuTap(gestureRecognizer:)))
        menuTapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.addGestureRecognizer(menuTapGestureRecognizer)
     
        let playPauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handlePlayPauseTap(gestureRecognizer:)))
        playPauseGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.addGestureRecognizer(playPauseGestureRecognizer)
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
    
    func reset() {
        
        self.textField.text = ""
        self.textViewPostit.text = self.postit?.text ?? ""
        self.textViewPostit.backgroundColor = (self.postit == nil ? UIColor.PostitTheme.blue : self.postit?.color)
        
        let initialColors = UIColor.PostitTheme.allColors.filter { $0 != self.textViewPostit.backgroundColor }
        
        (0...2).forEach { self.colorViews[$0].backgroundColor = initialColors[$0] }
    }
    
    private func setColorViewsTapGestures() {
        
        self.colorViews.forEach {
            let colorViewTapGestureRecoginzer = UITapGestureRecognizer(target: self, action: #selector(self.switchColorOnTap(gestureRecognizer:)))
            colorViewTapGestureRecoginzer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
            $0.addGestureRecognizer(colorViewTapGestureRecoginzer)
        }
        
    }
    
    //MARK: Gesture recognizers
    
    func handleMenuTap(gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didPressMenu(in: self)
    }
    
    func handlePlayPauseTap(gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didPressPlayPause(in: self)
    }
    
    func switchColorOnTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let oldColor = self.textViewPostit.backgroundColor
        let newColor = gestureRecognizer.view?.backgroundColor
        
        self.textViewPostit.backgroundColor = newColor
        gestureRecognizer.view?.backgroundColor = oldColor
    }
    
    //MARK: Focus engine
    
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
