//
//  CWBusinessModelCanvas.swift
//  jhkjh
//
//  Created by Williamberg on 08/02/17.
//  Copyright © 2017 padrao. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CWBusinessModelCanvas{
    
    let titleKey = "title"
    let imageKey = "image"
    
    var record: CKRecord
    var recordId : CKRecordID{
        return record.recordID
    }
    
    var keyPaternersBlock : CWBlock!
    var keyActivitiesBlock: CWBlock!
    var keyResourcesBlock : CWBlock!
    var valuePropositionsBlock : CWBlock!
    var custumerRelationshipsBlock : CWBlock!
    var channelsBlock : CWBlock!
    var custumerSegmentsBlock : CWBlock!
    var costStructureBlock : CWBlock!
    var revenueStreamsBlock : CWBlock!
    var blocks = [CWBlock]()
    
    var title: String{
        get{
            return record[titleKey] as! String
        }
        set{
            record[titleKey] = newValue as CKRecordValue?
        }
    }
    var image: UIImage{
        get{
            return UIImage.init(data: record[imageKey] as! Data )!
        }
        set{
            record[imageKey] = UIImagePNGRepresentation( newValue ) as CKRecordValue?
        }
    }
    
    init(title: String, image: UIImage) {
        record = CKRecord(recordType: "bmc")
        record[titleKey] = title as CKRecordValue?
        record[imageKey] = UIImagePNGRepresentation(image) as CKRecordValue?
        initBlocks()
    }
    
    init (withRecord record: CKRecord ){
        self.record = record
    }
    
    func initBlocks(){
        keyPaternersBlock = CWBlock.init(title: "Key Paterners", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 0, parent: self.record)
        
        keyActivitiesBlock = CWBlock.init(title: "Key Activities", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 1, parent: self.record)
        
        keyResourcesBlock = CWBlock.init(title: "Key Resources", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 2, parent: self.record)
        
        valuePropositionsBlock = CWBlock.init(title: "Value Propositions", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 3, parent: self.record)
        
        custumerRelationshipsBlock = CWBlock.init(title: "Custumer Relationships", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 4, parent: self.record)
        
        channelsBlock = CWBlock.init(title: "Channels", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 5, parent: self.record)
        
        custumerSegmentsBlock = CWBlock.init(title: "Custumer Segments", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 6, parent: self.record)
        costStructureBlock = CWBlock.init(title: "Cost Structure", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 7, parent: self.record)
        revenueStreamsBlock = CWBlock.init(title: "Revenue Streams", color: UIColor.white , icon: #imageLiteral(resourceName: "heart"), tag: 8, parent: self.record)
        
        blocks = [keyPaternersBlock, keyActivitiesBlock, keyResourcesBlock, valuePropositionsBlock, custumerRelationshipsBlock, channelsBlock, custumerSegmentsBlock, costStructureBlock, revenueStreamsBlock]
    }
    
    //save bmc on icloud.
    func save(competionHandler: @escaping ((_ sucess: Bool, _ bmc: CKRecord?) -> ())){
        CloudKitHelper.privateDB.save(self.record, completionHandler: { newBmc, error in
            if error == nil{
                competionHandler(true, newBmc)
            }
            else{
                competionHandler(false, newBmc)
            }
        })
    }
    
    class func createBmc(withTitle title: String, withImage image:UIImage,competionHandler: @escaping ((_ sucess: Bool, _ bmc: CWBusinessModelCanvas?) -> ())){
        
        let newBmc = CWBusinessModelCanvas.init(title: title, image: image)
        
        CloudKitHelper.privateDB.save( newBmc.record, completionHandler: { (record, error) in
            if error == nil{
                competionHandler(true, newBmc)
            }
            else{
                competionHandler(false, newBmc)
            }
        } )
    }
    
    class func saveBlocks(blocks: [CWBlock], competionHandler: @escaping ((_ sucess: Bool, _ bmc: CKRecord?) -> ())){
        var sucess = true
        for block in blocks{
            CloudKitHelper.privateDB.save(block.record, completionHandler: {
                record, erro in
                if erro != nil{
                    sucess = false
                }
                competionHandler(sucess, nil)
            })
        }
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
    
    func upadate(title: String?, image: UIImage?, competionHandler: @escaping ((_ sucess: Bool) -> ())){
        var modified = false
        
        if let newTitle = title{
            self.record[titleKey] = newTitle as CKRecordValue?
            modified = true
        }
        if let newImage = image{
            self.record[imageKey] = UIImagePNGRepresentation(newImage) as CKRecordValue?
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
    
    
    
}
