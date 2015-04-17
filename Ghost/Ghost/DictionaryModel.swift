//
//  DictionaryModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class DictionaryModel
{
    var dictionary : [String]
    var filtered : [String]
    
    init(words: String) {
        dictionary = words.componentsSeparatedByString("\n")
        filtered = dictionary
    }
    
    // Filters the complete list with a given word.
    func filter(word: String) {
        filtered = filtered.filter() { $0.hasPrefix(word) }
        println("\(word) \(filtered)")
    }
    
    // Returns the length of the words remaining in the filtered list.
    func count() -> Int {
        return filtered.count
    }
    
    // Returns the single remaining word in the list. If count != 1, return nil.
    func result() -> String? {
        if count() == 1 {
            return filtered[0]
        }
        return nil
    }
    
    // Reset filtered list to original dictionary.
    func reset() {
        filtered = dictionary
    }
    
    // Checks if the current word is in the filterd list of words.
    func isWord(word: String) -> Bool {
        return find(filtered, word) != nil
    }
}