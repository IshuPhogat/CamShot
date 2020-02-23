//
//  Cam_Shot.swift
//  CamShot
//
//  Created by LTDMM09 on 23/02/2020.
//  Copyright (c) 2020 IshwarSingh. All rights reserved.
//

import Foundation

public class Cam_Shot {
    
    /// static shared instance
    public static var shared = Cam_Shot()
    
    /// Timer object
    private var timerObject:Timer?
    
    private var syncProtocol = SyncNetwork()
    
    private init() {
        
    }

    // Scheduling Timer on video start
    private func scheduleTimer() {
        timerObject?.invalidate()
        timerObject = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(runTimer(_:)), userInfo: nil, repeats: true)
        timerObject?.fire()
    }
    
    // Run timer to update progress bar at bottom
    @objc private func runTimer(_ timer:Timer)  {
        guard let img = takeScreenshot() else { return }
        guard let data = img.jpeg(.medium) else {
            return
        }
        let imgName = "ScreenShot_\(Date().getDate()).jpg"
        CoreDataManager.shared.createRecord(data, recordId: getRecordId(), screenName: imgName)
        if Network.shared.isInternetAvailable {
            syncProtocol.syncCapturedImg()
            print("Internet Available")
        }
    }
    
    /// Takes the screenshot of the screen and returns the corresponding image
    private func takeScreenshot() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
    
    private func getRecordId() -> String {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var uniqueId = ""
        for _ in 0..<6 {
            guard let ch = str.randomElement() else { continue}
            uniqueId.append(ch)
        }
        return str
    }

}

extension Cam_Shot {
    
    public func start() {
        scheduleTimer()
    }
    
    public func stop() {
        timerObject?.invalidate()
    }
}



extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: jpegQuality.rawValue) ?? self.pngData()
    }
    
}
