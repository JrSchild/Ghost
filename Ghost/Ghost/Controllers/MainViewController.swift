//
//  MainViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 30-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var inputPlayer1 : UITextField!
    @IBOutlet weak var inputPlayer2 : UITextField!
    @IBOutlet weak var pickerPlayer1 : UIButton!
    @IBOutlet weak var pickerPlayer2 : UIButton!
    @IBOutlet weak var userPicker : UIPickerView!
    
    var currentPicker : UITextField!
    
    // TODO: Cache this in a singleton so it doesn't need to reload every time this view initializes.
    var users = loadUsers()
    var usernames : [String]
    
    required init(coder aDecoder: NSCoder) {
        
        // TEMP: If no users have been loaded, put some dummy data.
        if (users.count == 0) {
            users = ["Joey": 0, "Ally": 0, "Kaylie": 0, "Lisa": 0, "Lo": 0, "Wilene": 0, "Bas": 0]
            writeUsers(users)
        }
        usernames = Array(users.keys)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPlayer1.text = usernames[0]
        inputPlayer2.text = usernames[1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Un-focus the textfield when tapped outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        userPicker.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // When a game starts set the input of the player names to the new GameViewController.
        if segue.identifier == "startGame" {
            var gameViewController = segue.destinationViewController as GameViewController
            gameViewController.user1 = "\(inputPlayer1!.text)"
            gameViewController.user2 = "\(inputPlayer2!.text)"
            gameViewController.mainViewController = self
            
            // If the users didn't exist yet, add them and store. TODO: Move this to the users singleton?
            let currUsers = users.count
            if users[gameViewController.user1] == nil { users[gameViewController.user1] = 0 }
            if users[gameViewController.user2] == nil { users[gameViewController.user2] = 0 }
            if users.count > currUsers { writeUsers(users) }
            usernames = Array(users.keys)
        }
    }
    
    // Picker delegate methods.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usernames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(usernames[row])"
    }
    
    // When the picker closes set the text to the input field and hide it.
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        currentPicker.text = usernames[row]
        userPicker.hidden = true
    }
    
    // Hide picker when input field is focused.
    @IBAction func touchUpInside(sender: UITextField) {
        userPicker.hidden = true
    }
    
    // Show the username picker for player 1 and player 2.
    @IBAction func showPicker(sender: UIButton) {
        currentPicker = sender == pickerPlayer1 ? inputPlayer1 : inputPlayer2
        showPicker()
    }
    
    func showPicker() {
        self.view.endEditing(true)
        userPicker.hidden = false
    }
    
    func winner(name: String) {
        let refreshAlert = UIAlertView()
        refreshAlert.title = "GAME OVER \(name) Won"
        refreshAlert.addButtonWithTitle("OK")
        refreshAlert.show()
        
        // Up the score of the winner with one, and save it.
        users[name]?++
        writeUsers(users)
    }
}

// TODO: Move to users singleton?
let defaults = NSUserDefaults.standardUserDefaults()

// Store list of users in NSUserDefaults
func writeUsers(users: [String:Int]) {
    defaults.setObject(users, forKey: "users")
    defaults.synchronize()
}

// Load list of users from NSUserDefaults
func loadUsers() -> [String:Int] {
    if let users = defaults.objectForKey("users") as? [String:Int] {
        return users;
    }
    return [String:Int]()
}