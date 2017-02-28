//
//  UIColorExtensions.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 25/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

//MARK: Custom inits

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

//MARK: Custom colors

extension UIColor {
    
    struct PostitTheme {
        
        static let blue   = UIColor(withHex: 0xA7DEFF, alpha: 0.73)
        static let pink   = UIColor(withHex: 0xFFC7E8, alpha: 0.73)
        static let yellow = UIColor(withHex: 0xFFEFB4, alpha: 0.73)
        static let green  = UIColor(withHex: 0x408710, alpha: 0.73)
        
        static let allColors: [UIColor] = [blue, pink, yellow, green]
        
        static func index(of color: UIColor) -> Int16? {
            guard let index = self.allColors.index(of: color) else { return nil }
            return Int16(index)
        }
        
        static func color(for index: Int16) -> UIColor? {
            return self.allColors[Int(index)]
        }
    }
}










