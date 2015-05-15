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
    let defaults = NSUserDefaults.standardUserDefaults()
    let dictionary : DictionaryModel
    let user1 : String
    let user2 : String
    var currentUser = true
    var currentWord = ""
    
    // Required to retrieve state from gameViewController when saving.
    var gameViewController : GameViewController
    
    // Indicates which person started this round. Required for restoring game state after quit.
    var userStart = true
    
    init(dictionary: DictionaryModel, user1: String, user2: String, gameViewController: GameViewController) {
        self.dictionary = dictionary
        self.user1 = user1
        self.user2 = user2
        self.dictionary.reset()
        self.gameViewController = gameViewController
    }
    
    // add a letter to the current word
    func guess(letter: String)  -> Bool {
        
        // exactly one letter must be guessed
        if countElements(letter) != 1 {
            NSException.raise("Only one letter can be guessed!", format: "", arguments: getVaList([]))
        }
        
        currentWord += letter
        dictionary.filter(currentWord)
        
        turn()
        save()
        return currentUser
    }
    
    // returns the new player
    func turn() -> Bool {
        currentUser = !currentUser
        
        return currentUser
    }
    
    // Check if current word is more than three letters and inside the dictionary.
    func ended() -> Bool {
        return (countElements(currentWord) > 3 && dictionary.isWord(currentWord)) || dictionary.count() == 0
    }
    
    // Returns boolean indicating who won, nil if no user won.
    func winner() -> Bool? {
        return ended() ? currentUser : nil
    }
    
    // Save the current gamestate.
    func save() {
        var game = [String:AnyObject]()
        game["user1"] = user1
        game["user2"] = user2
        game["currentUser"] = currentUser
        game["currentWord"] = currentWord
        game["scoreUser1"] = gameViewController.scoreUser1
        game["scoreUser2"] = gameViewController.scoreUser2
        game["userStart"] = gameViewController.userStart
        
        defaults.setObject(game, forKey: "game")
        defaults.synchronize()
    }
    
    // Destroy the saved gamestate.
    func destroy() {
        defaults.removeObjectForKey("game")
    }
}
