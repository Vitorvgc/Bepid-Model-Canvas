//
//  CloudkitHelper.swift
//  C. Williamberg
//
//  Created by C. Williamberg on 10/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitHelper: NSObject {
    
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
    
    static func isICloudContainerAvailable(competionHandler: @escaping (_ sucess: Bool) -> ()) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            if error == nil && accountStatus == .available{
                competionHandler(true)
            }
            else{
                competionHandler(false)
            }
        }
    }
    
    static func icloudStatus(competionHandler: @escaping (_ status: CKAccountStatus, _ error: Error? ) -> () ){
        CKContainer.default().accountStatus {
            (accountStatus, error) in
            competionHandler(accountStatus, error)
        }
    }
    
    static func screenShotMethod() -> UIImage?{
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
