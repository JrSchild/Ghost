//
//  GameModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class GameModel
{
    let dictionary : DictionaryModel
    let user1 : String
    let user2 : String
    var currentUser = true
    var currentWord = ""
    
    init(dictionary: DictionaryModel, user1: String, user2: String) {
        self.dictionary = dictionary
        self.user1 = user1
        self.user2 = user2
        self.dictionary.reset()
    }
    
    // add a letter to the current word
    func guess(letter: String)  -> Bool {
        // exactly one letter must be guessed
        if countElements(letter) != 1 {
            NSException.raise("Only one letter can be guessed!", format: "", arguments: getVaList([]))
        }
        
        currentWord += letter
        dictionary.filter(currentWord)
        
        return turn()
    }
    
    // returns the new player
    func turn() -> Bool {
        currentUser = !currentUser
        
        return currentUser
    }
    
    // check if current word is more than three letters and inside the dictionary
    func ended() -> Bool {
        return (countElements(currentWord) > 3 && dictionary.isWord(currentWord)) || dictionary.count() == 0
    }
    
    // Returns boolean indicating who won, nil if no user won.
    func winner() -> Bool? {
        return ended() ? currentUser : nil
    }
}
