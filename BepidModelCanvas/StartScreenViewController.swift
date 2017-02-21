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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloukKitHelper.icloudStatus()
        

//        CWBusinessModelCanvas.createBmc(withTitle: "bmc0", competionHandler: {
//            sucess, bmc in
//            if sucess {
//                print("bmc salvo com sucesso.")
//                if let bmcCreated = bmc{
//                    CWBusinessModelCanvas.saveBlocks(blocks: bmcCreated.blocks, competionHandler:
//                        {sucess, record in
//                            if sucess{
//                                CWPostit.createPostit(withTitle: "posit tv0", andText: "first posit", andColor: UIColor.blue, parent: bmcCreated.blocks[1].record, competionHandler: {
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
//        
        
        
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
            }
            else{
                print(" bmc doesnt exist!")
            }
        })
        
//        let query = CKQuery(recordType: "postit", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
//                CloukKitHelper.privateDB.perform(query, inZoneWith: nil) { (records, error) in
//        
//                    if error == nil {
//        
//                        for record in records! {
//                            CloukKitHelper.privateDB.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
//        
//                                if error == nil {
//        
//                                    print("Record deleted")
//        
//                                }
//        
//                            })
//
//                        }
//                        
//                    }
//                    
//                }
//        
    }
    
    @IBOutlet weak var CanvaImage: UIImageView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1 //numero de bmc + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teste", for: indexPath) as! CanvasModelsCollectionViewCell
        if indexPath.row == 0 {
            cell.CanvaImage.image = #imageLiteral(resourceName: "newCanvasDemo")
            cell.CanvaTitle.text! = "Add new canvas"
        }
        
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
        performSegue(withIdentifier: "OpenCanvas", sender: cell)
    }
    
    
    ///ADICIONAR DADOS IMPORTANTES PARA A NAVEGAÇÃO
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }

}
