//
//  ViewController.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 03/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var views: [BlockView]!
    @IBOutlet var blocks: [UICollectionView]!
    
    var isNewCanvas: Bool!
    var bmc: BusinessModelCanvas!
    var bmcBlocks = [Block]()
    var postits = [[Postit]]()
    
    var dao = CoreDataDAO<Postit>()
    
    var postitQuantity = [Int](repeating: 2, count: 9)
    
    var editedPostitPosition: (tag: Int, position: IndexPath, new: Bool)?
    
    var cellSize: CGSize {
        let width = self.blocks[0].frame.size.width * 0.8
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blocks.forEach {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "PostitCell", bundle: nil), forCellWithReuseIdentifier: "PostitCell")
            $0.register(UINib(nibName: "ButtonCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCell")
            $0.register(UINib(nibName: "PostitType", bundle: nil), forCellWithReuseIdentifier: "PostitType")
        }
        
        self.views.forEach {
            $0.collectionView = $0.subviews.filter { $0 is UICollectionView }.first as! UICollectionView!
        }
        
        if(isNewCanvas == true) {
            bmc.initializeBlocks()
        }
        
        self.bmcBlocks = bmc.blocks?.sorted(by: { (first, second) -> Bool in
            (first as! Block).tag < (second as! Block).tag
        }) as! [Block]
        
        self.postits = (0...8).map { bmcBlocks[$0].postits?.allObjects as! [Postit] }
        
        print("[DEBUG] blocks: \(self.bmcBlocks)")
        print("[DEBUG] postits: \(self.postits)")
    }

    
    //MARK: CollectionView Data Source
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postits[collectionView.tag].count + 1//postitQuantity[collectionView.tag]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Add a editing postit if anyone is selected
        if self.isEditingCell(at: collectionView, in: indexPath) {
            
            let editingPostitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitType", for: indexPath) as! PostitType
            
            editingPostitCell.resizeOutlets()
            editingPostitCell.delegate = self
            
            return editingPostitCell
        }
    
        // Add a plus button if this is the last cell
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {

            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell

            buttonCell.onSelection = { self.updatePostit(at: collectionView, in: indexPath, isNew: true) }

            return buttonCell
        }

        // Otherwise create a normal postit cell
        let postitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitCell", for: indexPath) as! PostitCell
        
        postitCell.resizeOutlets()
        postitCell.onSelection = { self.updatePostit(at: collectionView, in: indexPath, isNew: false) }
        postitCell.titleTextField.text = "title \(indexPath.row)"
        postitCell.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.73)
        
        return postitCell
    }
    
    
    //MARK: CollectionView Delegate Flow Layout
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !self.isEditingCell(at: collectionView, in: indexPath) {
            return self.cellSize
        }
        else {
            return CGSize(width: self.cellSize.width, height: self.cellSize.height * 2)
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let verticalInset = self.cellSize.height * 0.15
        let horizontalInset = self.cellSize.width * 0.15
        
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    
    //MARK: View methods
    
    
    private func updatePostit(at collectionView: UICollectionView, in indexPath: IndexPath, isNew: Bool) {
        self.editedPostitPosition = (tag: collectionView.tag, position: indexPath, new: isNew)
        if(isNew) {
            postitQuantity[collectionView.tag] += 1
        }
        collectionView.reloadData()
    }
    
    fileprivate func isEditingCell(at collectionView: UICollectionView, in indexPath: IndexPath) -> Bool {
        return (editedPostitPosition != nil && editedPostitPosition!.tag == collectionView.tag && editedPostitPosition!.position == indexPath)
    }
    
}


//MARK: PostitTypeDelegate


extension ViewController: PostitTypeDelegate {
    
    func didPressMenu() {
        let tag = self.editedPostitPosition!.tag
        let index = self.editedPostitPosition!.position
        let isNew = self.editedPostitPosition!.new
        let collectionView = self.blocks[tag]
        
        let cell = collectionView.cellForItem(at: index) as! PostitType
        cell.reset()
        
        if(isNew) {
            // if it would be a new postit, remove it
            self.postitQuantity[tag] -= 1
        }
        self.editedPostitPosition = nil
 
        collectionView.reloadData()
    }
    
    func didPressPlayPause(in cell: PostitType) {
        let tag = self.editedPostitPosition!.tag
        let index = self.editedPostitPosition!.position
        let isNew = self.editedPostitPosition!.new
        let collectionView = self.blocks[tag]
        
        let cell = collectionView.cellForItem(at: index) as! PostitType
        cell.reset()
        
        self.editedPostitPosition = nil
        // TODO: update postit if it is an existing one, or insert a new one otherwise
        // currently without CoreData, it justs inserts a default postit
        if(isNew) {
            let postit = dao.new()
            postit.block = bmcBlocks.filter { Int($0.tag) == index.row }.first
            postit.text = cell.text
            postit.color = Int16(UIColor.PostitTheme.index(of: cell.selectedColor)!)
            
            print("[DEBUG] new postit: \(postit.text) \(postit.color) \(postit.block?.tag)")
            dao.insert(object: postit)
        }
        
        
        collectionView.reloadData()
    }
    
}

