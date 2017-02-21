//
//  CoreDataDAO.swift
//  BepidModelCanvas
//
//  Created by Vítor Chagas on 21/02/17.
//  Copyright © 2017 BepidCanvas. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    
    static var className: String {
        return String(describing: self)
    }
}

class CoreDataDAO<Element: NSManagedObject>: DAO {

    private var context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.managedObjectContext
    }
    
    func insert(object: Element) {
        self.context.insert(object)
        self.save()
    }
    
    func delete(object: Element) {
        self.context.delete(object)
        self.save()
    }
    
    func all() -> [Element] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Element.className)
        let result = try! self.context.fetch(request) as! [Element]
        return result
    }
    
    func new() -> Element {
        return NSEntityDescription.insertNewObject(forEntityName: Element.className, into: self.context) as! Element
    }
    
    private func save() {
        try! self.context.save()
    }
    
}
