//
//  UserModel.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 12-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class UserModel
{
    let defaults = NSUserDefaults.standardUserDefaults()
    var users : [String:Int]
    var usernames = [String]()
    
    init() {
        if let users = defaults.objectForKey("users") as? [String:Int] {
            self.users = users
        } else {
            self.users = [String:Int]()
        }
        
        // TEMP: If no users have been loaded, put some dummy data.
        if (users.count == 0) {
            users = ["Joey": 8, "Ally": 7, "Kaylie": 7, "Lisa": 3, "Lo": 1, "Wilene": 0, "Bas": 0]
        }
        
        sort()
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
        sort()
    }
    
    func up(name: String) {
        // users[name]!++ Crashes
        users[name]? = users[name]! + 1
        sort()
    }
    
    func sort() {
        usernames = sorted(users.keys, { user1, user2 in
            self.users[user1] > self.users[user2]
        })
        save()
    }
    
    func save() {
        defaults.setObject(users, forKey: "users")
        defaults.synchronize()
    }
    
    // Reset the score of all users.
    func clearScore() {
        
        // Same workaround as in addUserIfNotExists
        var usersTmp = users
        for user in usernames {
            usersTmp[user] = 0
        }
        users = usersTmp
        sort()
        save()
    }
    
    func clearUsers() {
        users = [String:Int]()
        sort()
        save()
    }
}
