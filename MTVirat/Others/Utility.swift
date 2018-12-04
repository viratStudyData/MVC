//
//  Utility.swift
//  TestVirat
//
//  Created by cbl16 on 7/27/18.
//  Copyright © 2018 Codebrew. All rights reserved.
//

import UIKit

class Utility: NSObject {
    internal class func encodeObject(objectName object: AnyObject, keyName: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
        defaults.set(encodedData, forKey: keyName)
        defaults.synchronize()
    }
    
    internal class func decodedObjecte(_ keyName: String) -> Any? {
        let decodedObject = defaults.object(forKey: keyName) as! Data
        if let object = NSKeyedUnarchiver.unarchiveObject(with: decodedObject) {
            return object
        }
        return nil
    }
    
}
