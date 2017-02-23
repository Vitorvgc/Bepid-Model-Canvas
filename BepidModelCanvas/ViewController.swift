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
    
    var postitQuantity = [Int](repeating: 2, count: 9)
    
    var editedPostitPosition: (tag: Int, position: IndexPath)?
    
    var cellSize: CGSize {
        let width = self.blocks[0].frame.size.width * 0.8
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
        CloukKitHelper.getAllRecords(fromEntity: "bmc", competionHandler: {
            sucess, records in
            if sucess{
                if let recs = records{
                    print("bmc count \(recs.count)")
                    for rec in recs{
                        let bmc = CWBusinessModelCanvas.init(withRecord: rec)
                        print("title: \(bmc.title) key: \(bmc.recordId)")
                        CloukKitHelper.getAllChildren(fromRecordID: rec.recordID, childEntity: "block", competionHandler: {
                            sucess, records in
                            if sucess{
                                print("blocks count: \(records?.count)")
                                for blockRec in records!{
                                    print("block title: \(blockRec["title"])")
                                    CloukKitHelper.getAllChildren(fromRecordID: blockRec.recordID, childEntity: "postit", competionHandler: {
                                        sucess, records in
                                        if sucess{
                                            print("block title: \(blockRec["title"])")
                                            print("posit count \(records?.count)")
                                        }
                                    })
                                }
                            }
                        })
                        
                    }
                }
                else{
                    print(" bmc doesnt exist!")
                }
            }
        })
        
//        CWBusinessModelCanvas.createBmc(withTitle: "bmc TV", competionHandler: {
//            sucess, bmc in
//            if sucess {
//                print("bmc salvo com sucesso.")
//                if let bmcCreated = bmc{
//                    CWBusinessModelCanvas.saveBlocks(blocks: bmcCreated.blocks, competionHandler:
//                        {sucess, record in
//                            if sucess{
//                                CWPostit.createPostit(withTitle: "positTv", andText: "posit from tv", andColor: UIColor.blue, parent: bmcCreated.blocks[0].record, competionHandler: {
//                                    sucess, positRecord in
//                                    if sucess{
//                                        print("posit  salvo")
//                                    }
//                                    else{
//                                        print("falha ao salvar posit")
//                                    }
//                                })
//                            }
//                            
//                    })
//                }
//            }
//            else{
//                print("falha ao salvar bmc")
//            }
//        })
        
        
    }

    
    //MARK: CollectionView Data Source
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postitQuantity[collectionView.tag]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Add a editing postit if anyone is selected
        if self.isEditingCell(at: collectionView, in: indexPath) {
            let editingPostitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitType", for: indexPath) as! PostitType
            editingPostitCell.resizeOutlets()
            
            return editingPostitCell
        }
    
        // Add a plus button if this is the last cell
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {

            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell

            buttonCell.resizeOutlets()
            buttonCell.onSelection = { self.createNewPostit(at: collectionView, in: indexPath) }

            return buttonCell
        }

        // Otherwise create a normal postit cell
        let postitCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostitCell", for: indexPath) as! PostitCell
        
        postitCell.resizeOutlets()
        postitCell.titleTextField.text = "title \(indexPath.row)"
        postitCell.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.73)
        
        return postitCell
    }

    
    //MARK: CollectionView Delegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[CV] didSelectItem")
        self.editedPostitPosition = (tag: collectionView.tag, position: indexPath)
        collectionView.reloadData()
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
    
    
    private func createNewPostit(at collectionView: UICollectionView, in indexPath: IndexPath) {
        self.editedPostitPosition = (tag: collectionView.tag, position: indexPath)
        postitQuantity[collectionView.tag] += 1
        collectionView.reloadData()
    }
    
    private func isEditingCell(at collectionView: UICollectionView, in indexPath: IndexPath) -> Bool {
        return (editedPostitPosition != nil && editedPostitPosition!.tag == collectionView.tag && editedPostitPosition!.position == indexPath)
    }
    
}

