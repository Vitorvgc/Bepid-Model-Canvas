//
//  CWBlock.swift
//  C. Williamberg
//
//  Created by Williamberg on 08/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import UIKit
import CloudKit

class CWBlock{
    
    let titleKey = "title"
    let colorKey = "color"
    let iconKey  = "icon"
    let parentKey = "parent"
    
    var record: CKRecord
    var recordId : CKRecordID{
        return record.recordID
    }
    var bmcRef: CKReference
    
    var title: String{
        get{
            return record[titleKey] as! String
        }
        set{
            record[titleKey] = newValue as CKRecordValue?
        }
    }
    var color: UIColor{
        get{
            return CWBlock.intToColor(num:  record[colorKey] as! Int16)
        }
        set{
            record[colorKey] = CWBlock.colorToInt(color: newValue ) as CKRecordValue?
        }
    }
    var icon : UIImage{
        get{
            return UIImage.init(data: record[iconKey] as! Data )!
        }
        set{
            record[iconKey] = UIImagePNGRepresentation( newValue ) as CKRecordValue?
        }
    }
    
    
    init(title: String, color: UIColor?, icon:UIImage, parent: CKRecord) {
        let record = CKRecord(recordType: "block")
        record[titleKey]  = title as CKRecordValue?
        if let positColor = color{
            record[colorKey] = CWBlock.colorToInt(color: positColor) as CKRecordValue?
        }
        else{
            record[colorKey] = CWBlock.colorToInt(color: UIColor.white) as CKRecordValue?
        }
        record[iconKey] = UIImagePNGRepresentation(icon) as CKRecordValue?
        self.bmcRef = CKReference.init(record: parent, action: .deleteSelf)
        record[parentKey] = self.bmcRef
        self.record = record
    }
    
    init (withRecord record: CKRecord, parent: CKRecord ){
        self.record = record
        self.bmcRef = CKReference.init(record: parent, action: .deleteSelf)
    }
    
    class func createBlock(withTitle title: String, andColor color: UIColor?, andIcon icon: UIImage,parent: CKRecord, competionHandler: @escaping ((_ sucess: Bool, _ block: CWBlock?) -> ())){
        
        let newBlock = CWBlock.init(title: title, color: color, icon: icon, parent: parent)
        CloukKitHelper.publicDB.save( newBlock.record, completionHandler: { (record, error) in
            if error == nil{
                competionHandler(true, newBlock)
            }
            else{
                competionHandler(false, newBlock)
            }
        } )
    }
    
    func destroy( _ competionHandler: @escaping ((_ sucess: Bool) -> ()) ){
        CloukKitHelper.publicDB.delete(withRecordID: self.recordId){ (recordId, error) in
            if error == nil{
                competionHandler(true)
            }
            else{
                competionHandler(false)
            }
        }
    }
    
    //returns all postit from icloud related with this block, if none exists return nil
    //    static func getAllPostit(competionHandler: @escaping ((_ sucess: Bool, _ records: [CKRecord]?) -> ())){
    //        let predicate = NSPredicate.init(format: "", <#T##args: CVarArg...##CVarArg#>)
    //        let query     = CKQuery.init(recordType: "bmc", predicate: predicate)
    //        publicDB.perform(query, inZoneWith: nil, completionHandler: {
    //            records, error in
    //            if error == nil{
    //                competionHandler(true, records)
    //            }
    //            else{
    //                competionHandler(false, records)
    //            }
    //
    //        })
    //    }
    
    static func colorToInt(color: UIColor) -> Int{
        switch color {
        case UIColor.green :
            return 0
        case UIColor.yellow:
            return 1
        default:
            return -1
        }
    }
    
    static func intToColor(num: Int16) -> UIColor{
        switch num {
        case 0:
            return .green
        case 1:
            return .yellow
            
        default:
            return .white
        }
    }
}


