//
//  Item.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/10/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Item) class Item: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var serialNumber: String?
    @NSManaged var dateCreated: NSDate
    @NSManaged var itemKey: String
    @NSManaged var thumbnail: UIImage?
    @NSManaged var orderingValue: Double
    @NSManaged var valueInDollars: NSNumber
    @NSManaged var assetType: NSManagedObject?

    /*
    Creates a thumbnail in the table view
    */
    func setThumbnailFromImage(image: UIImage) {
        let origImageSize = image.size
        
        let newRect = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let ratio = max(newRect.size.width / origImageSize.width,
            newRect.size.height / origImageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)
        
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        path.addClip()
        
        var projectRect = CGRectZero
        projectRect.size.width = ratio * origImageSize.width
        projectRect.size.height = ratio * origImageSize.height
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0
        
        image.drawInRect(projectRect)
        
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage
        
        UIGraphicsEndImageContext()
    }
    
    /*
    Called when Item objects are added to the database
    */
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        dateCreated = NSDate()
        
        // Create an NSUUID object and get its string representation
        let uuid = NSUUID()
        let key = uuid.UUIDString
        itemKey = key
    }
    
}
