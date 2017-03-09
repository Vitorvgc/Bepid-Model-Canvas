//
//  StartScreenViewController.swift
//  telainicialtvos
//
//  Created by Renata Faria on 16/02/17.
//  Copyright © 2017 Renata Faria. All rights reserved.
//

import UIKit
import CloudKit

class StartScreenViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var BmcCollectionView: UICollectionView!
    @IBOutlet weak var CanvaImage: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bmcs = [CWBusinessModelCanvas]()
    var blocks = [CWBlock]()
    var postits = [ [CWPostit ] ]( repeating: [], count: 9)
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBmc = CWBusinessModelCanvas(title: "Add New Canvas", image: #imageLiteral(resourceName: "newCanvasDemo"))
        bmcs.append(newBmc)
        
        showLoadingIndicator()
        CloudKitHelper.isICloudContainerAvailable(competionHandler: {
            sucess in
            if sucess{
                CloudKitHelper.getAllRecords(fromEntity: "bmc", competionHandler: {
                    sucess, records in
                    if sucess{
                        if let recs = records{
                            recs.forEach{
                                let bmc = CWBusinessModelCanvas.init(withRecord: $0)
                                self.bmcs.append(bmc)
                                self.BmcCollectionView.reloadData()
                            }
                        }
                        self.hideLoadingIndicator()
                    }
                    else{
                        print(" bmc doesnt exist!")
                    }
                    self.actvityIndicator.stopAnimating()
                })
            }
            else{
                self.hideLoadingIndicator()
                print("icloud is not avalaible")
            }
        })

//                let query = CKQuery(recordType: "block", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//                        CloudKitHelper.privateDB.perform(query, inZoneWith: nil) { (records, error) in
//        
//                            if error == nil {
//        
//                                for record in records! {
//                                    CloudKitHelper.privateDB.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
//        
//                                        if error == nil {
//        
//                                            print("Record deleted")
//        
//                                        }
//        
//                                    })
//        
//                                }
//        
//                            }
//                            
//                        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.BmcCollectionView.reloadData()
        self.pressCell = false
    }
    
    func showLoadingIndicator(){
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teste", for: indexPath) as! CanvasModelsCollectionViewCell
        
        let bmc = bmcs[indexPath.row]
        cell.CanvaImage.image = bmc.image
        cell.CanvaTitle.text! = bmc.title
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 48, 0, 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 435, height: 315)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if((context.nextFocusedIndexPath) != nil){
            let cell = collectionView.cellForItem(at: context.nextFocusedIndexPath!) as! CanvasModelsCollectionViewCell
            self.CanvaImage.image = cell.CanvaImage.image
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bmcSelected = bmcs[indexPath.row]
        
        showLoadingIndicator()
        if bmcSelected === bmcs.first{
            
            let newBmc = CWBusinessModelCanvas(title: "title", image: #imageLiteral(resourceName: "newCanvasDemo"))
            newBmc.save(competionHandler: {
                sucess, _ in
                if sucess{
                    CWBusinessModelCanvas.saveBlocks(blocks: newBmc.blocks, competionHandler: {
                        sucess, blockRecords in
                        if sucess{
                            print("save blocks sucessul")
                            self.blocks = newBmc.blocks
                            self.blocks.sort{ $0.tag < $1.tag }
                            //self.blocks.forEach{ _ in self.postits.append([CWPostit]())}
                            DispatchQueue.main.async {
                                self.hideLoadingIndicator()
                                self.performSegue(withIdentifier: "OpenCanvas", sender: newBmc)
                            }
                        }
                    })
                }
            })
        }
        else{
            CloudKitHelper.getAllChildren(fromRecordID: (bmcSelected.recordId), childEntity: "block",     competionHandler: {
                sucess, recordBlocks in
                if sucess{
                    
                    for recBlock in recordBlocks!{
                        let block = CWBlock(withRecord: recBlock, parent: bmcSelected.record)
                        self.blocks.append(block)
                    }
                    self.blocks.sort{ $0.tag < $1.tag }
                    for block in self.blocks{
                        CloudKitHelper.getAllChildren(fromRecordID: block.record.recordID, childEntity: "postit", competionHandler: {
                            sucess, postitRecords in
                            if sucess{
                                var postitArray = [CWPostit]()
                                for postitRec in postitRecords!{
                                    let postit = CWPostit(withRecord: postitRec)
                                    postitArray.append(postit)
                                }
                                self.postits[block.tag] = postitArray
                                self.index = self.index + 1
                                if self.index == self.blocks.count{
                                    self.index = 1
                                    DispatchQueue.main.async {
                                        self.hideLoadingIndicator()
                                        self.performSegue(withIdentifier: "OpenCanvas", sender: bmcSelected)
                                    }

                                }
                            }
                            
                        })
                    }
                    
                }
                else{
                    print("cant get blocks..")
                }
            })
        }
        self.pressCell = true
    }
    
    
    ///ADICIONAR DADOS IMPORTANTES PARA A NAVEGAÇÃO
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        viewController.bmc = sender as! CWBusinessModelCanvas
        viewController.bmcBlocks = self.blocks
        viewController.bmcPostits = self.postits
    }

}
