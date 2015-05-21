//
//  GameModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class GameModel {
    
    let dictionary : DictionaryModel
    var gameRound : GameRoundModel
    let finalWord = "GHOST"
    let user1 : String
    let user2 : String
    var scoreUser1 = 0
    var scoreUser2 = 0
    
    // Indicates which person started this round. Required for restoring game state after quit.
    var userStart = true
    
    init(dictionary: DictionaryModel, user1: String, user2: String) {
        self.dictionary = dictionary
        self.user1 = user1
        self.user2 = user2
        self.gameRound = GameRoundModel(dictionary: dictionary, userStart: userStart)
        save()
    }
    
    func newRound() {
        userStart = !userStart
        self.gameRound = GameRoundModel(dictionary: dictionary, userStart: userStart)
        save()
    }
    
    // Add a letter to the current word.
    func guess(letter: String) {
        gameRound.guess(letter)
        save()
    }
    
    // Returns boolean indicating who won, nil if no user won.
    func roundWinner() -> Bool? {
        if gameRound.isEnded() {
            
            // One-up score of loser.
            if gameRound.winner! {
                ++scoreUser2
            } else {
                ++scoreUser1
            }
            return gameRound.winner!
        }
        return nil
    }
    
    func isGameOver() -> String? {
        if (gameRound.winner! ? scoreUser2 : scoreUser1) >= countElements(finalWord) {
            destroy()
            return gameRound.winner! ? user1 : user2
        }
        return nil
    }
    
    // Save the current gamestate.
    func save() {
        GameStorage.saveGameModel(self)
    }
    
    // Destroy the saved gamestate.
    func destroy() {
        GameStorage.destroy()
    }
}

class GameRoundModel {
    
    let dictionary : DictionaryModel
    var winner : Bool!
    var currentUser : Bool
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

struct GameStorage {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static func destroy() {
        GameStorage.defaults.removeObjectForKey("game")
    }
    
    static func saveGameModel(game: GameModel) {
        var gameData : [String:AnyObject] = [
            "user1": game.user1,
            "user2": game.user2,
            "currentUser": game.gameRound.currentUser,
            "currentWord": game.gameRound.currentWord,
            "scoreUser1": game.scoreUser1,
            "scoreUser2": game.scoreUser2,
            "userStart": game.userStart
        ]
        
        defaults.setObject(gameData, forKey: "game")
        defaults.synchronize()
    }
    
    static func loadGameData() -> [String:AnyObject]? {
        return NSUserDefaults.standardUserDefaults().objectForKey("game") as? [String:AnyObject]
    }
    
    static func restoreGameModel(dictionary: DictionaryModel, gameData: [String:AnyObject]) -> GameModel {
        var game = GameModel(dictionary: dictionary, user1: gameData["user1"] as String, user2: gameData["user2"] as String)
        game.gameRound.currentWord = gameData["currentWord"] as String
        game.gameRound.currentUser = gameData["currentUser"] as Bool
        game.scoreUser1 = gameData["scoreUser1"] as Int
        game.scoreUser2 = gameData["scoreUser2"] as Int
        game.userStart = gameData["userStart"] as Bool
        
        return game
    }
}
