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
    var blocks:[CWBlock]!
    
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
    
    init(title: String) {
        record = CKRecord(recordType: "bmc")
        record[titleKey] = title as CKRecordValue?
        record[imageKey] = UIImagePNGRepresentation(#imageLiteral(resourceName: "checkMark")) as CKRecordValue?
        initBlocks()
    }
    
    init (withRecord record: CKRecord ){
        self.record = record
        initBlocks()
    }
    
    func initBlocks(){
        keyPaternersBlock = CWBlock.init(title: "Key Paterners", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        keyActivitiesBlock = CWBlock.init(title: "Key Activities", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        keyResourcesBlock = CWBlock.init(title: "Key Resources", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        valuePropositionsBlock = CWBlock.init(title: "Value Propositions", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        custumerRelationshipsBlock = CWBlock.init(title: "Custumer Relationships", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        channelsBlock = CWBlock.init(title: "Channels", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        custumerSegmentsBlock = CWBlock.init(title: "Custumer Segments", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        costStructureBlock = CWBlock.init(title: "Cost Structure", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        revenueStreamsBlock = CWBlock.init(title: "Revenue Streams", color: UIColor.white , icon: #imageLiteral(resourceName: "checkMark"), parent: self.record)
        
        blocks = [keyPaternersBlock, keyActivitiesBlock, keyResourcesBlock, valuePropositionsBlock, custumerRelationshipsBlock, channelsBlock, custumerSegmentsBlock, costStructureBlock, revenueStreamsBlock]
    }
    
    class func createBmc(withTitle title: String, competionHandler: @escaping ((_ sucess: Bool, _ bmc: CWBusinessModelCanvas?) -> ())){
        
        let newBmc = CWBusinessModelCanvas.init(title: title)
        
        CloukKitHelper.publicDB.save( newBmc.record, completionHandler: { (record, error) in
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
            CloukKitHelper.publicDB.save(block.record, completionHandler: {
                record, erro in
                if erro != nil{
                    sucess = false
                }
            })
        }
        competionHandler(sucess, nil)
        
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
    
    
    
}
