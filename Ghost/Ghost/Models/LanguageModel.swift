//
//  LanguageModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 14-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class LanguageModel {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let languages = ["English", "Dutch"]
    var language : String
    
    init() {
        if let language = defaults.objectForKey("language") as? String {
            self.language = language
        } else {
            self.language = languages[0]
            save()
        }
    }
    
    func setLanguage(language: String) {
        self.language = language
        save()
    }
    
    func setLanguage(languageIndex: Int) {
        if languages.count > languageIndex {
            setLanguage(languages[languageIndex])
        }
    }
    
    func save() {
        defaults.setObject(language, forKey: "language")
        defaults.synchronize()
    }
}
