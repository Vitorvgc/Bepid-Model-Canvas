//
//  PostitView.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 16/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class PostitView: UIView {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
