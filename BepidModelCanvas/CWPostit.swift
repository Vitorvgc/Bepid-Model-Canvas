//
//  Postit.swift
//  C. Williamberg
//
//  Created by Williamberg on 07/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import UIKit
import CloudKit


class CWPostit {
    
    let titleKey = "title"
    let textKey  = "text"
    let colorKey = "color"
    let parentKey = "parent"
    
    var record: CKRecord
    var recordId : CKRecordID{
        return record.recordID
    }
    var blockRef: CKReference
    
    var title: String{
        get{
            return record[titleKey] as! String
        }
        set{
            record[titleKey] = newValue as CKRecordValue?
        }
    }
    var text: String{
        get{
            return record[textKey] as! String
        }
        set{
            record[textKey] = newValue as CKRecordValue?
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
    
    init(title: String, text: String, color: UIColor?, parent: CKRecord) {
        let record = CKRecord(recordType: "postit")
        record[titleKey]  = title as CKRecordValue?
        record[textKey] = text as CKRecordValue?
        if let positColor = color{
            record[colorKey] = UIColor.PostitTheme.index(of: positColor) as CKRecordValue?
        }
        else{
            record[colorKey] = UIColor.PostitTheme.index(of: UIColor.PostitTheme.blue) as CKRecordValue?
        }
        blockRef = CKReference.init(record: parent, action: .deleteSelf)
        record[parentKey] = blockRef
        self.record = record
        
    }
    
    init (withRecord record: CKRecord ){
        self.record = record
        self.blockRef = record[parentKey] as! CKReference
    }
    
    class func createPostit(withTitle title: String, andText text: String, andColor color: UIColor?,parent: CKRecord, competionHandler: @escaping ((_ sucess: Bool, _ postit: CWPostit?) -> ())){
        
        let newPostit = CWPostit.init(title: title, text: text, color: color, parent: parent)
        CloudKitHelper.privateDB.save( newPostit.record, completionHandler: { (record, error) in
            if error == nil{
                competionHandler(true, newPostit)
            }
            else{print(error.debugDescription)
                competionHandler(false, newPostit)
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
    
    func upadate(title: String?, text: String?, color: UIColor?,competionHandler: @escaping ((_ sucess: Bool) -> ())){
        var modified = false
        
        if let title = title, title != self.title {
            self.record[titleKey] = title as CKRecordValue?
            modified = true
        }
        if let text = text, text != self.text {
            self.record[textKey] = text as CKRecordValue?
            modified = true
        }
        if let color = color, color != self.color {
            self.record[colorKey] = UIColor.PostitTheme.index(of: color) as CKRecordValue?
            modified = true
        }
        if modified {
            
            CloudKitHelper.privateDB.save(self.record, completionHandler: {
                record, error in
                if error == nil {
                    competionHandler(true)
                }
            })
        }
        competionHandler(false)
    }
    
}
