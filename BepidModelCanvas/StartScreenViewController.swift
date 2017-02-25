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

    var bmcs = [CWBusinessModelCanvas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloukKitHelper.icloudStatus()
        let addNewCanvas = CWBusinessModelCanvas(title: "Add new canvas", image: #imageLiteral(resourceName: "newCanvasDemo"))
        bmcs.append(addNewCanvas)
        
        CloukKitHelper.getAllRecords(fromEntity: "bmc", competionHandler: {
            sucess, records in
            if sucess{
                if let recs = records{
                    for rec in recs{
                        let bmc = CWBusinessModelCanvas.init(withRecord: rec)
                        self.bmcs.append(bmc)
                    }
                    self.BmcCollectionView.reloadData()
                }
            }
            else{
                
                print(" bmc doesnt exist!")
            }
        })
               
    }
    
    @IBOutlet weak var CanvaImage: UIImageView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
         //return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 435, height: 315)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if((context.nextFocusedIndexPath) != nil){
            let cell = try! collectionView.cellForItem(at: context.nextFocusedIndexPath!) as! CanvasModelsCollectionViewCell
            self.CanvaImage.image = cell.CanvaImage.image
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CanvasModelsCollectionViewCell
        performSegue(withIdentifier: "OpenCanvas", sender: indexPath)
    }
    
    
    ///ADICIONAR DADOS IMPORTANTES PARA A NAVEGAÇÃO
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //let viewController = segue.destination as! ViewController
        //viewController.bmc = bmcs[(sender as! IndexPath).row]
    }

}
