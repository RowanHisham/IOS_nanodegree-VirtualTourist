//
//  DataController.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/25/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
        
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        
        persistentContainer.loadPersistentStores { storesDescription, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }
}
