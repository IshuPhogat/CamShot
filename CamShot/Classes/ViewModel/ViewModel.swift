//
//  ViewModel.swift
//  CamShot
//
//  Created by LTDMM09 on 23/02/2020.
//  Copyright (c) 2020 IshwarSingh. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseSyncing {
    
    private static var isSyncying = false
    
    static func syncImages() {
        if isSyncying && !Network.shared.isInternetAvailable { return }
        guard let records = CoreDataManager.shared.fetchRecords(NSPredicate(format: "isSync = '0'")), records.count > 0 else { return }
        isSyncying = true
        let group = DispatchGroup()
        for record in records {
            guard let data = record.screeshot, let imgName = record.screenName else { continue }
            group.enter()
            let storageRef = Storage.storage().reference().child(imgName)
            storageRef.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else{
                    record.isSync = true
                    CoreDataManager.shared.saveContext()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isSyncying = false
        }
    }
}
