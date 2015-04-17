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
    var score = 0
    var currentUser = true
    var currentWord = ""
    
    init(dictionary: DictionaryModel) {
        self.dictionary = dictionary
    }
    
    // add a letter to the current word
    func guess(letter: String) {
        let pp = Array(letter)
        
        if pp.count >= 1 {
            currentWord += "\(pp[0])"
            dictionary.filter(currentWord)
        }
    }
    
    // returns the new player
    func turn() -> Bool {
        currentUser = !currentUser
        
        return currentUser
    }
    
    // check if current word is more than three letters and inside the dictionary
    func ended() -> Bool {
        return countElements(currentWord) > 3 && dictionary.isWord(currentWord)
    }
    
    // Returns boolean indicating who won, nil if no user won.
    func winner() -> Bool? {
        if ended() {
            return currentUser
        }
        return nil
    }
    
    // TODO; Don't double initialize these variables. How to make dry? Do we want these variables to be optionals?
    func start() {
        user1 = ""
        user2 = ""
        score = 0
        currentUser = true
        currentWord = ""
        dictionary.reset()
    }
}