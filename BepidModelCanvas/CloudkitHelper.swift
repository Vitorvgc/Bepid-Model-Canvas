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
    
}
