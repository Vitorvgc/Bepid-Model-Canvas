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
    
    var dao = CoreDataDAO<Postit>()
    
    var postitQuantity = [Int](repeating: 2, count: 9)
    
    var editedPostitPosition: (tag: Int, position: IndexPath, new: Bool)?
    
    var bmcBlocks: [Block] {
        return bmc.blocks?.sorted { ($0 as! Block).tag < ($1 as! Block).tag } as! [Block]
    }
    
    var postits: [[Postit]] {
        return (0...8).map { bmcBlocks[$0].postits?.allObjects as! [Postit] }
    }
    
    var cellSize: CGSize {
        let width = self.blocks[0].frame.size.width * 0.8
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[DEBUG] \(bmc)")
        print("[DEBUG] \(isNewCanvas)")
        
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
            editingPostitCell.postit = (indexPath.row < postits[collectionView.tag].count ?
                postits[collectionView.tag][indexPath.row] :
                nil)
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
        
        let postit = postits[collectionView.tag][indexPath.row]
        
        postitCell.resizeOutlets()
        postitCell.onSelection = { self.updatePostit(at: collectionView, in: indexPath, isNew: false) }
        postitCell.postit = postit
        
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
        
        
        // TODO: update postit if it is an existing one, or insert a new one otherwise
        // currently without CoreData, it justs inserts a default postit
        if(isNew) {
            let postit = dao.new()
            
            let blocks = bmcBlocks
            print("[DEBUG] BMC blocks: ")
            blocks.forEach {
                print("[DEBUG] \($0.title) \($0.tag) \($0.businessModelCanvas === self.bmc)")
                print("[DEBUG] postits: \((($0.postits?.allObjects) as! [Postit]).map { $0.text })")
            }
            
            postit.block = bmcBlocks.filter { Int($0.tag) == tag }.first
            postit.text = cell.text
            postit.color = Int16(UIColor.PostitTheme.index(of: cell.selectedColor)!)
            
            print("[DEBUG] new postit: \(postit.text) \(postit.color) \(postit.block?.tag)")
            dao.insert(object: postit)
        }
        else {
            let postit = cell.postit!
            postit.text = cell.text
            postit.color = Int16(UIColor.PostitTheme.index(of: cell.selectedColor)!)
            dao.save()
            print("[DEBUG] updated postit: \(postit.entity) \(postit.text) \(postit.color)")
        }
        
        self.editedPostitPosition = nil
        cell.reset()
        collectionView.reloadData()
        
        print("[DEBUG] bmcs:")
        CoreDataDAO<BusinessModelCanvas>().all().forEach {
            print("[DEBUG]   \($0.title)")
        }
    }
    
}

