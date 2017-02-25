//
//  UIColorExtensions.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 25/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(withHex hex: Int) {
        let red   = CGFloat(hex >> 16) / 255.0
        let green = CGFloat(hex >> 8 & 0xFF) / 255.0
        let blue  = CGFloat(hex  & 0xFF) / 255.0
        
        self.init(red: red, green: green , blue: blue, alpha: 1.0)
    }
    
    convenience init(withHex hex: Int, alpha: CGFloat) {
        let red   = CGFloat(hex >> 16) / 255.0
        let green = CGFloat(hex >> 8 & 0xFF) / 255.0
        let blue  = CGFloat(hex  & 0xFF) / 255.0
        
        self.init(red: red, green: green , blue: blue, alpha: alpha)
    }
    
}
