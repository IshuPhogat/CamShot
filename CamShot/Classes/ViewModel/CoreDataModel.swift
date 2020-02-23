//
//  CoreDataModel.swift
//  CamShot
//
//  Created by IshwarSingh on 23/02/2020.
//  Copyright (c) 2020 IshwarSingh. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    let identifier: String  = "org.cocoapods.CamShot"
    let model: String       = "CamShotSdk"
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(for: CoreDataManager.self) //Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("Loading of store failed:\(err)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
}

extension CoreDataManager {
    public func createRecord(_ imgData: Data?, recordId: String, screenName: String, isSync: Bool = false){
        let detail = CapturedDetails.init(context: context)
        detail.isSync = isSync
        detail.screeshot = imgData
        detail.record_Id = recordId
        detail.capturedDate = Date()
        detail.screenName = screenName
        saveContext()
        
    }
    
    func fetchRecords(_ predicate : NSPredicate? = nil) -> [CapturedDetails]?{
        let fetchRequest: NSFetchRequest<CapturedDetails> = CapturedDetails.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteRecord(_ record: CapturedDetails) {
        context.delete(record)
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension Date {
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy_HH:mm:ss"
        let myStringafd = formatter.string(from: self)
        return myStringafd
    }
}
