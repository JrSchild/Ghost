//
//  Storage.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 21-05-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//
//  Provide basic key-value storage methods for saving, loading and deleting.
//

import Foundation

// Abstract basic storage methods so this can be easily swapped out into another type of key-value store.
struct Storage {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static func save(key: String, data: AnyObject) {
        defaults.setObject(data, forKey: key)
        defaults.synchronize()
    }
    
    static func load(key: String) -> AnyObject? {
        return defaults.objectForKey(key)
    }
    
    static func remove(key: String) {
        defaults.removeObjectForKey(key)
    }
}
