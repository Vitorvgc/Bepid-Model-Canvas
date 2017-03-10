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
    let tagKey   = "tag"
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
            return UIColor.PostitTheme.color(for: record[colorKey] as! Int16)!
        }
        set{
            record[colorKey] = UIColor.PostitTheme.index(of: newValue) as CKRecordValue?
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
    var tag: Int{
        get{
            return record[tagKey] as! Int
        }
        set{
            record[tagKey] = newValue as CKRecordValue?
        }
    }
    
    init(title: String, color: UIColor?, icon:UIImage, tag: Int, parent: CKRecord) {
        let record = CKRecord(recordType: "block")
        record[titleKey]  = title as CKRecordValue?
        if let blockColor = color{
            record[colorKey] = UIColor.PostitTheme.index(of: blockColor) as CKRecordValue?
        }
        else{
            record[colorKey] = UIColor.PostitTheme.index(of: UIColor.PostitTheme.blue) as CKRecordValue?
        }
        record[iconKey] = UIImagePNGRepresentation(icon) as CKRecordValue?
        record[tagKey] = tag as CKRecordValue?
        self.bmcRef = CKReference.init(record: parent, action: .deleteSelf)
        record[parentKey] = self.bmcRef
        self.record = record
    }
    
    init (withRecord record: CKRecord, parent: CKRecord ){
        self.record = record
        self.bmcRef = CKReference.init(record: parent, action: .deleteSelf)
    }
    
    class func createBlock(withTitle title: String, andColor color: UIColor?, andIcon icon: UIImage,tag: Int, parent: CKRecord, competionHandler: @escaping ((_ sucess: Bool, _ block: CWBlock?) -> ())){
        
        let newBlock = CWBlock.init(title: title, color: color, icon: icon, tag: tag, parent: parent)
        CloudKitHelper.privateDB.save( newBlock.record, completionHandler: { (record, error) in
            if error == nil{
                competionHandler(true, newBlock)
            }
            else{
                competionHandler(false, newBlock)
            }
        } )
    }
    
    func destroy( _ competionHandler: @escaping ((_ sucess: Bool) -> ()) ){
        CloudKitHelper.privateDB.delete(withRecordID: self.recordId){ (recordId, error) in
            if error == nil{
                competionHandler(true)
            }
            else{
                competionHandler(false)
            }
        }
    }
}


