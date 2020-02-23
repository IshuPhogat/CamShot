//
//  NetworkProtocol.swift
//  CamShot
//
//  Created by LTDMM09 on 23/02/2020.
//  Copyright (c) 2020 IshwarSingh. All rights reserved.
//

import Foundation


protocol NetworkProtocol {
    func syncCapturedImg()
}


extension NetworkProtocol {
    func syncCapturedImg() {
        print("Netwrok protoc called")
        FirebaseSyncing.syncImages()
        
    }
}

struct SyncNetwork: NetworkProtocol {
    
}
