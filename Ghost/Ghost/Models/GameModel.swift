//
//  GameModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

class GameModel {
    
    let dictionary: DictionaryModel
    var round: GameRoundModel
    let finalWord = "GHOST"
    let user1: String
    let user2: String
    var scoreUser1 = 0
    var scoreUser2 = 0
    
    // Indicates which user starts the next round.
    var userStart = true
    
    init(dictionary: DictionaryModel, user1: String, user2: String) {
        self.dictionary = dictionary
        self.user1 = user1
        self.user2 = user2
        round = GameRoundModel(dictionary: dictionary, userStart: userStart)
        save()
    }
    
    func newRound() {
        userStart = !userStart
        round = GameRoundModel(dictionary: dictionary, userStart: userStart)
        save()
    }
    
    // Add a letter to the current word.
    func guess(letter: String) {
        round.guess(letter)
        save()
    }
    
    // Returns boolean indicating who won, nil if no user won.
    func roundWinner() -> Bool? {
        if round.isEnded() {
            
            // One-up score of loser.
            if round.winner! {
                ++scoreUser2
            } else {
                ++scoreUser1
            }
            return round.winner!
        }
        return nil
    }
    
    func isGameOver() -> String? {
        if (round.winner! ? scoreUser2 : scoreUser1) >= countElements(finalWord) {
            destroy()
            return round.winner! ? user1 : user2
        }
        return nil
    }
    
    // Save the current gamestate.
    func save() {
        GameStorage.save(self)
    }
    
    // Destroy the saved gamestate.
    func destroy() {
        GameStorage.destroy()
    }
}
