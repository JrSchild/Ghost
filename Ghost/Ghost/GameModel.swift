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
    var dictionary : DictionaryModel
    
    var user1 = ""
    var user2 = ""
    var score1 = 0
    var score2 = 0
    var currentUser = true
    var currentWord = ""
    
    init(dictionary: DictionaryModel) {
        self.dictionary = dictionary
    }
    
    // add a letter to the current word
    func guess(letter: String) {
        // exactly one letter must be guessed
        if countElements(letter) != 1 {
            NSException.raise("Only one letter can be guessed!", format: "", arguments: getVaList([]))
        }
        
        currentWord += letter
        dictionary.filter(currentWord)
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
        if ended() {
            return currentUser
        }
        return nil
    }
}