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
            return CWPostit.intToColor(num: record[colorKey] as! Int16)
        }
        set{
            record[colorKey] = CWPostit.colorToInt(color: newValue) as CKRecordValue?
        }
    }
    
    init(title: String, text: String, color: UIColor?, parent: CKRecord) {
        let record = CKRecord(recordType: "postit")
        record[titleKey]  = title as CKRecordValue?
        record[textKey] = text as CKRecordValue?
        if let positColor = color{
            record[colorKey] = CWPostit.colorToInt(color: positColor) as CKRecordValue?
        }
        else{
            record[colorKey] = CWPostit.colorToInt(color: UIColor.white) as CKRecordValue?
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
    
    //get all exercice from the user from cloudkit
    //    class func list( _ completionHandeler:@escaping ((_ sucess: Bool, _ exercicios:[String])->()) ){
    //
    //        let query = CKQuery(recordType: "usuario", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
    //        CloukKitHelper.publicDB.perform(query, inZoneWith: nil){ (results, error) in
    //
    //            let exercicios = [String]()
    //            if error == nil{
    //                let user = Usuario(withRecord: results![0])
    //                completionHandeler(true, user.exercicios)
    //            }
    //            else{
    //                completionHandeler(false, exercicios)
    //            }
    //        }
    //    }
    
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
        
        if let newTitle = title{
            self.record[titleKey] = newTitle as CKRecordValue?
            modified = true
        }
        if let newText = text{
            self.record[textKey] = newText as CKRecordValue?
            modified = true
        }
        if let newColor = color{
            self.record[colorKey] = CWPostit.colorToInt(color: newColor) as CKRecordValue?
            modified = true
        }
        if modified{
            CloudKitHelper.privateDB.save(self.record, completionHandler: {
                record, error in
                if error == nil{
                    competionHandler(true)
                }
            })
        }
        competionHandler(false)
    }
    
    
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
