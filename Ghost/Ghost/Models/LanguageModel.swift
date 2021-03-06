//
//  LanguageModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 14-05-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//
//  Store current language and provide methods for choosing another language.
//

class LanguageModel {
    
    let languages = ["English", "Dutch"]
    var language: String
    
    init() {
        if let language = Storage.load("language") as? String {
            self.language = language
        } else {
            self.language = languages[0]
            save()
        }
    }
    
    func setLanguage(language: String) {
        if contains(languages, language) {
            self.language = language
            save()
        }
    }
    
    func setLanguage(languageIndex: Int) {
        if languages.count > languageIndex {
            setLanguage(languages[languageIndex])
        }
    }
    
    func save() {
        Storage.save("language", data: language)
    }
}
