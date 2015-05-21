//
//  DictionaryStorage.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 21-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

// Define static helper method for loading the dictionary.
struct DictionaryStorage {
    
    static let mainBundle = NSBundle.mainBundle()
    
    static func load(language: String) -> String? {
        let path = mainBundle.pathForResource(language, ofType: nil)
        
        return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
    }
}
