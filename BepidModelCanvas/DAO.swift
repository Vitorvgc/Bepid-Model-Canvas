//
//  DAO.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 21/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import Foundation

protocol DAO {

    associatedtype Object
    
    func insert(object: Object)
    func delete(object: Object)
    func all() -> [Object]
}
