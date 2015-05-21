//
//  UserModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 12-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

class UserModel {
    
    var users: [String:Int]
    var usernames = [String]()
    
    init() {
        if let users = Storage.load("users") as? [String:Int] {
            self.users = users
        } else {
            self.users = [:]
        }
        
        // TEMP: If no users have been loaded, put some dummy data.
        if (users.count == 0) {
            users = ["Joey": 8, "Ally": 7, "Kaylie": 7, "Lisa": 3, "Lo": 1, "Wilene": 0, "Bas": 0]
        }
        
        save()
    }
    
    func addUserIfNotExists(name: String) {
        if users[name] != nil {
            return
        }
        
        // Set the new username on the score.
        // For some reason setting directly throws: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
        var usersTmp = users
        usersTmp[name] = 0
        users = usersTmp
        save()
    }
    
    func up(name: String) {
        // users[name]!++ Crashes
        users[name]? = users[name]! + 1
        save()
    }
    
    // Set list of usernames sorted by highscore and save everything.
    func save() {
        usernames = sorted(users.keys, { user1, user2 in
            self.users[user1] > self.users[user2]
        })
        
        Storage.save("users", data: users)
    }
    
    // Reset the score of all users.
    func clearScore() {
        
        // Same workaround as in addUserIfNotExists
        var usersTmp = users
        for user in usernames {
            usersTmp[user] = 0
        }
        users = usersTmp
        save()
    }
    
    func clearUsers() {
        users = [:]
        save()
    }
}
