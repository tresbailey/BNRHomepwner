//
//  ImageStore.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/9/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    var imageDict = [String:UIImage]()
    
    /*
    Init method for registering to get Low Memory Notfiications
    */
    override init() {
        super.init()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "clearCache:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    /*
    Removes all images from the cache
    */
    func clearCache(note: NSNotification) {
        println("Flushing \(imageDict.count) images out of the cache")
        imageDict.removeAll(keepCapacity: false)
    }
    
    
    /* 
    Creates a new path in the documents directory for storing images
    */
    func imagePathForKey(key: String) -> String {
        let documentsDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = documentsDirectories.first as String
        
        return documentDirectory.stringByAppendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        imageDict[key] = image
        
        // Create full path for image
        let imagePath = imagePathForKey(key)
        
        // Turn image into JPEG data
        // Could use UIImagePNGRepresentation for Bronze Challenge
        let data = UIImageJPEGRepresentation(image, 0.5)
        
        // Write it to full path
        data.writeToFile(imagePath, atomically: true)
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = imageDict[key] {
            return existingImage
        } else {
            let imagePath = imagePathForKey(key)
            
            if let imageFromDisk = UIImage(contentsOfFile: imagePath) {
                setImage(imageFromDisk, forKey: key)
                return imageFromDisk
            } else {
                return nil
            }
            
        }
    }
    
    func deleteImageForKey(key: String) {
        imageDict.removeValueForKey(key)
        
        let imagePath = imagePathForKey(key)
        NSFileManager.defaultManager().removeItemAtPath(imagePath, error: nil)
    }
}
