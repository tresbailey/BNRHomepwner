//
//  ImageTransformer.swift
//  Homepwner
//
//  Created by Tres Bailey on 12/10/14.
//  Copyright (c) 2014 TRESBACK. All rights reserved.
//

import UIKit

@objc(ImageTransformer) class ImageTransformer: NSValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if value == nil {
            return nil
        }
        
        if value is NSData {
            return value
        } else {
            return UIImagePNGRepresentation(value as UIImage)
        }
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        return UIImage(data: value as NSData)
    }
   
}
