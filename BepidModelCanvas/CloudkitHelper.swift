//
//  CloudkitHelper.swift
//  C. Williamberg
//
//  Created by padrao on 10/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloukKitHelper: NSObject {
    
    //static let container = CKContainer(identifier: "iCloud.com.bepidcanvas.BepidModelCanvas")
    static let container = CKContainer.default()
    
    static var publicDB: CKDatabase{
        return container.publicCloudDatabase
    }
    
    static var privateDB: CKDatabase{
        return container.privateCloudDatabase
    }
    
    //returns all records of a entity type from icloud, if none exists return nil
    static func getAllRecords(fromEntity entity: String, competionHandler: @escaping ((_ sucess: Bool, _ records: [CKRecord]?) -> ())){
        let predicate = NSPredicate.init(value: true)
        let query     = CKQuery.init(recordType: entity, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil, completionHandler: {
            records, error in
            if error == nil{
                competionHandler(true, records)
            }
            else{
                competionHandler(false, records)
            }
            
        })
    }
    
    //returns all records of a entity type from icloud, if none exists return nil
    static func getAllChildren(fromRecordID recordId: CKRecordID, childEntity: String,competionHandler: @escaping ((_ sucess: Bool, _ records: [CKRecord]?) -> ())){
        let predicate = NSPredicate.init(format: "parent = %@", recordId)
        let query     = CKQuery.init(recordType: childEntity, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil, completionHandler: {
            records, error in
            if error == nil{
                competionHandler(true, records)
            }
            else{
                competionHandler(false, records)
            }
            
        })
    }
    
    static func isICloudContainerAvailable() -> Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            return true
        }
        else {
            return false
        }
    }
    
    static func icloudStatus(){
        CKContainer.default().accountStatus { (accountStatus, error) in
            switch accountStatus {
            case .available:
                print("iCloud Available")
            case .noAccount:
                print("No iCloud account")
            case .restricted:
                print("iCloud restricted")
            case .couldNotDetermine:
                print("Unable to determine iCloud status")
            }
        }
    }
    
    static func screenShotMethod() -> UIImage?{
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
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

//    CloukKitHelper.getAllRecords(fromEntity: "bmc", competionHandler: {
//    sucess, records in
//    if sucess{
//    if let recs = records{
//    print("bmc count \(recs.count)")
//    for rec in recs{
//    let bmc = CWBusinessModelCanvas.init(withRecord: rec)
//    print("title: \(bmc.title) key: \(bmc.recordId)")
//    CloukKitHelper.getAllChildren(fromRecordID: rec.recordID, childEntity: "block", competionHandler: {
//    sucess, records in
//    if sucess{
//    print("blocks count: \(records?.count)")
//    for blockRec in records!{
//    print("block title: \(blockRec["title"])")
//    CloukKitHelper.getAllChildren(fromRecordID: blockRec.recordID, childEntity: "postit", competionHandler: {
//    sucess, records in
//    if sucess{
//    print("block title: \(blockRec["title"])")
//    print("posit count \(records?.count)")
//    }
//    })
//    }
//    }
//    })
//    }
//    }
//    }
//    else{
//    print(" bmc doesnt exist!")
//    }
//    })
//    
    
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

    
}
