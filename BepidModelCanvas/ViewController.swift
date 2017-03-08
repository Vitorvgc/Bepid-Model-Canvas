//
//  ViewController.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 03/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,PostitCellDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var views: [BlockView]!
    @IBOutlet var blocks: [UICollectionView]!
    
//    var bmc: BusinessModelCanvas!
//    var dao = CoreDataDAO<Postit>()
    var editedPostitPosition: (tag: Int, position: IndexPath)?
//    var bmcBlocks: [Block] {
//        return bmc.blocks?.sorted { ($0 as! Block).tag < ($1 as! Block).tag } as! [Block]
//    }
//    var postits: [[Postit]] {
//        return (0...8).map { bmcBlocks[$0].postits?.allObjects as! [Postit] }
//    }
    
    var bmc: CWBusinessModelCanvas!
    var bmcBlocks: [CWBlock]!
    var bmcPostits: [ [CWPostit] ]!
    
    var cellSize: CGSize {
        let width = self.blocks[0].frame.size.width * 0.8
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.text = bmc.title
        
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
        
        let menuTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMenuTap(gestureRecognizer:)))
        menuTapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuTapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viw start")
        bmcBlocks.sort(by: { $0.tag < $1.tag })//sort the block by tag.
        bmcBlocks.forEach{
            block in
            CloudKitHelper.getAllChildren(fromRecordID: block.recordId, childEntity: "postit", competionHandler: {
                sucess, records in
                if sucess{
                    var postits = [CWPostit]()
                    records?.forEach{
                        let postit = CWPostit(withRecord: $0)
                        postits.append(postit)
                    }
                    self.bmcPostits.insert(postits, at: block.tag)
                }
            })
        }
        print("view finish")
    }

    //When the user press on menu button. Update/Save bmc and postits. OBS: blocks are not modified so we dont care about it.
    func handleMenuTap(gestureRecognizer: UITapGestureRecognizer) {
        
        self.bmc.title = self.titleTextField.text!
        self.bmc.image = CloudKitHelper.screenShotMethod()!
        self.bmc.upadate(title: self.bmc.title, image: self.bmc.image, competionHandler: {
            sucess in
            if sucess{
                print("update bmc")
            }
        })
        self.bmcPostits.forEach{ postits in
            postits.forEach{
                $0.upadate(title: $0.title, text: $0.text, color: $0.color, competionHandler: {
                    sucess in
                    if sucess{
                        print("update postit")
                    }
                })
        }
        self.dismiss(animated: true, completion: {

//            self.bmc.title = self.titleTextField.text!
//            self.bmc.image = UIImagePNGRepresentation(CloudKitHelper.screenShotMethod()!) as NSData?
//            CoreDataDAO<BusinessModelCanvas>().save()
        })
    }
    }
    
    //MARK: CollectionView Data Source
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
        let quantity = self.bmcPostits[collectionView.tag].count
        if let focusedBlockView = self.blockWith(collectionView: collectionView), focusedBlockView.isEditing {
            return quantity + 1
        }
        return quantity
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Add a editing postit if anyone is selected
        if self.isEditingCell(at: collectionView, in: indexPath) {
            
            let editingPostitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitType", for: indexPath) as! PostitType
            
            editingPostitCell.resizeOutlets()
            editingPostitCell.delegate = self
            editingPostitCell.postit = (indexPath.row < bmcPostits[collectionView.tag].count ?
                bmcPostits[collectionView.tag][indexPath.row] :
                nil)
            return editingPostitCell
        }
    
        // Add a plus button if this is the last cell
        if blockWith(collectionView: collectionView)!.isEditing && indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {

            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell

            buttonCell.onSelection = { self.updatePostit(at: collectionView, in: indexPath, isNew: true) }

            return buttonCell
        }

        // Otherwise create a normal postit cell
        let postitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitCell", for: indexPath) as! PostitCell
        
        let postit = bmcPostits[collectionView.tag][indexPath.row]
        
        postitCell.resizeOutlets()
        postitCell.onSelection = { self.updatePostit(at: collectionView, in: indexPath, isNew: false) }
        postitCell.postit = postit
        postitCell.delegate = self
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
    
    private func blockWith(collectionView: UICollectionView) -> BlockView? {
        return self.views.filter { $0.collectionView == collectionView }.first
    }
    
    private func updatePostit(at collectionView: UICollectionView, in indexPath: IndexPath, isNew: Bool) {
        self.editedPostitPosition = (tag: collectionView.tag, position: indexPath)
        collectionView.reloadData()
    }
    
    fileprivate func isEditingCell(at collectionView: UICollectionView, in indexPath: IndexPath) -> Bool {
        return (editedPostitPosition != nil && editedPostitPosition!.tag == collectionView.tag && editedPostitPosition!.position == indexPath)
    }
    
    func didLongPress(in cell: PostitCell) {
              performSegue(withIdentifier: "GoToDeleteScreen", sender: cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToDeleteScreen" {
        if let deleteScreen = segue.destination as? DeleteViewController {
            let cell = sender as! PostitCell
            deleteScreen.getSelected(postitFocused: cell )
            }
        }
    }
    
    
}


//MARK: PostitTypeDelegate


extension ViewController: PostitTypeDelegate {
    
    func didPressMenu(in cell: PostitType) {
        
        let tag = self.editedPostitPosition!.tag
        let collectionView = self.blocks[tag]
        
        cell.reset()
        self.editedPostitPosition = nil
        collectionView.reloadData()
    }
    
    func didPressPlayPause(in cell: PostitType) {
        
        let tag = self.editedPostitPosition!.tag
        let collectionView = self.blocks[tag]
        
        if(cell.postit == nil) {
            
            let postit = CWPostit(title: "", text: cell.text, color: cell.selectedColor, parent: (bmcBlocks.filter { Int($0.tag) == tag }.first?.record)!)
            cell.postit = postit
            self.bmcPostits[tag].append(postit)
            CWPostit.createPostit(withTitle: "", andText: cell.text, andColor: cell.selectedColor, parent: (bmcBlocks.filter { Int($0.tag) == tag }.first?.record)!, competionHandler: {
                sucess, postit in
                if sucess{
                    print("postit saved with sucess")
                }
                else{
                    print("postit not saved.")
                }
            })
        }
        else {
            let postit = cell.postit!
                postit.upadate(title: nil, text: cell.text, color: cell.selectedColor, competionHandler:
                    { sucess in
                        if sucess{
                            print("postit updated with sucess")
                        }
                        else{
                            print("postit not updated.")
                        }
                })
        }
        
        self.editedPostitPosition = nil
        cell.reset()
        collectionView.reloadData()

    }
    
}

