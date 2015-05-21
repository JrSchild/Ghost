//
//  GameStorage.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 21-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

// Define static helper methods for persisting the GameModel.
struct GameStorage {
    
    static func destroy() {
        Storage.remove("game")
    }
    
    static func saveGameModel(game: GameModel) {
        var gameData : [String:AnyObject] = [
            "user1": game.user1,
            "user2": game.user2,
            "currentUser": game.round.currentUser,
            "currentWord": game.round.currentWord,
            "scoreUser1": game.scoreUser1,
            "scoreUser2": game.scoreUser2,
            "userStart": game.userStart
        ]
        
        Storage.save("game", data: gameData)
    }
    
    static func loadGameData() -> [String:AnyObject]? {
        return Storage.load("game") as? [String:AnyObject]
    }
    
    static func restoreGameModel(dictionary: DictionaryModel, gameData: [String:AnyObject]) -> GameModel {
        var game = GameModel(dictionary: dictionary, user1: gameData["user1"] as String, user2: gameData["user2"] as String)
        game.round.currentWord = gameData["currentWord"] as String
        game.round.currentUser = gameData["currentUser"] as Bool
        game.scoreUser1 = gameData["scoreUser1"] as Int
        game.scoreUser2 = gameData["scoreUser2"] as Int
        game.userStart = gameData["userStart"] as Bool
        
        return game
    }
}
