//
//  CloudkitHelper.swift
//  C. Williamberg
//
//  Created by padrao on 10/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import Foundation
import CloudKit

class CloukKitHelper: NSObject {
    
    static let container = CKContainer(identifier: "iCloud.com.bepidcanvas.BepidModelCanvas")
    
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
        publicDB.perform(query, inZoneWith: nil, completionHandler: {
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
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: {
            records, error in
            if error == nil{
                competionHandler(true, records)
            }
            else{
                competionHandler(false, records)
            }
            
        })
    }
    
}
