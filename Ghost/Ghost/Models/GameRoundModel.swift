//
//  GameRoundModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 21-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class GameRoundModel {
    
    let dictionary: DictionaryModel
    var winner: Bool!
    var currentUser: Bool
    var currentWord = ""
    
    init(dictionary: DictionaryModel, userStart: Bool) {
        self.dictionary = dictionary
        self.currentUser = userStart
        
        dictionary.reset()
    }
    
    // Add a letter to the current word.
    func guess(letter: String) {
        
        // exactly one letter must be guessed
        if countElements(letter) != 1 {
            NSException.raise("Only one letter can be guessed!", format: "", arguments: getVaList([]))
        }
        
        currentWord += letter
        dictionary.filter(currentWord)
        turn()
    }
    
    func isEnded() -> Bool {
        
        // Check if current word is more than three letters and inside the dictionary.
        if (countElements(currentWord) > 3 && dictionary.isWord(currentWord)) || dictionary.count() == 0 {
            winner = currentUser
            return true
        }
        return false
    }
    
    // Returns the new player.
    func turn() -> Bool {
        currentUser = !currentUser
        
        return currentUser
    }
}
