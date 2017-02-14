//
//  CloudkitHelper.swift
//  jhkjh
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
    
}
