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
            else{//cant get bmc from icloud
                self.hideLoadingIndicator()
                let alertController = UIAlertController(title: "Tv BMC", message: "You must be logged in on icloud to save your bmc.\nVerify your wifi connection and your icloud account status.", preferredStyle: UIAlertControllerStyle.alert)
                        
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in}
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.BmcCollectionView.reloadData()
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
        cell.delegate = (indexPath.row == 0 ? nil : self)
        cell.bmc = bmc
        
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
            self.bmcs.append(newBmc)
            newBmc.save(competionHandler: {
                sucess, _ in
                if sucess{
                    CWBusinessModelCanvas.saveBlocks(blocks: newBmc.blocks, competionHandler: {
                        sucess, blockRecords in
                        if sucess{
                            print("save blocks sucessul")
                            self.blocks = newBmc.blocks
                            self.blocks.sort{ $0.tag < $1.tag }
                            DispatchQueue.main.async {
                                self.hideLoadingIndicator()
                                self.performSegue(withIdentifier: "OpenCanvas", sender: newBmc)
                            }
                        }
                        else{
                            let alertController = UIAlertController(title: "Unable to save bmc", message: "You must be logged in on icloud to save your bmc.\nVerify your wifi connection.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in}
                            alertController.addAction(okAction)
                            DispatchQueue.main.async {
                                self.hideLoadingIndicator()
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    })
                }
                else{
                    let alertController = UIAlertController(title: "Unable to save bmc", message: "You must be logged in on icloud to save your bmc. \nVerify your wifi connection.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in}
                    alertController.addAction(okAction)
                    DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                        self.present(alertController, animated: true, completion: nil)
                    }
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
                            else{
                                let alertController = UIAlertController(title: "Unable to get bmc from icloud.", message: "You must be logged in on icloud to get your bmc.\nVerify your wifi connection.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                                    (result : UIAlertAction) -> Void in}
                                alertController.addAction(okAction)
                                DispatchQueue.main.async {
                                    self.hideLoadingIndicator()
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        })
                    }
                    
                }
                else{
                    let alertController = UIAlertController(title: "Unable to get bmc from icloud.", message: "You must be logged in on icloud to get your bmc.\nVerify your wifi connection.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in}
                    alertController.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }                }
            })
        }
    }
    
    ///ADICIONAR DADOS IMPORTANTES PARA A NAVEGAÇÃO
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        viewController.bmc = sender as! CWBusinessModelCanvas
        viewController.bmcBlocks = self.blocks
        viewController.bmcPostits = self.postits
    }

}

extension StartScreenViewController: CanvasModelDelegate {
    
    func didLongPress(cell: CanvasModelsCollectionViewCell) {
        let alertController = UIAlertController(title: "Delete BMC", message: "If you delete it, all data will be deleted too. Are you sure you want to delete this BMC?", preferredStyle: UIAlertControllerStyle.alert)
        
        let DestructiveAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            cell.bmc.destroy({
                sucess in
                if sucess{
                    print("bmc deleted")
                }
                else{
                    print("bmc not deleted")
                }
            })
            var index = 0
            for i in (0..<self.bmcs.count) {
                if(cell.bmc.record == self.bmcs[i].record) {
                    index = i
                    break
                }
            }

            self.bmcs.remove(at: index)
            self.BmcCollectionView.reloadData()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
