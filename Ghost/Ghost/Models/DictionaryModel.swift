//
//  DictionaryModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//
//  Store, filter and reset a dictionary.
//

class DictionaryModel {
    
    private let dictionary: [String]
    private var filtered: [String]
    
    init(words: String) {
        dictionary = words.componentsSeparatedByString("\n")
        filtered = dictionary
    }
    
    // Filters the complete list with a given word.
    func filter(word: String) {
        filtered = filtered.filter { $0.hasPrefix(word) }
    }
    
    // Returns the length of the words remaining in the filtered list.
    func count() -> Int {
        return filtered.count
    }
    
    // Returns the single remaining word in the list. If count != 1, return nil.
    func result() -> String? {
        return count() == 1 ? filtered[0] : nil
    }
    
    // Reset filtered list to original dictionary.
    func reset() {
        filtered = dictionary
    }
    
    // Checks if the current word is in the filterd list of words.
    func isWord(word: String) -> Bool {
        return contains(filtered, word)
    }
}
