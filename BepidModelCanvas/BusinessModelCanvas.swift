//
//  BusinessModelCanvas.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 25/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

extension BusinessModelCanvas {
    
    public func initializeBlocks() {
        
        let daoBlocks = CoreDataDAO<Block>()
        let blockSet = NSMutableSet()
        
        for i in (0...8) {
            let block = daoBlocks.new()
            block.title = Block.values[i].title
            block.icon = UIImagePNGRepresentation(Block.values[i].icon) as NSData?
            block.tag = Int16(i)
            block.postits = []
            blockSet.add(block)
        }
        
        self.blocks = blockSet
    }
}
