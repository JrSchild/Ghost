//
//  MainViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 30-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var inputPlayer1: UITextField!
    @IBOutlet weak var inputPlayer2: UITextField!
    @IBOutlet weak var userPicker: UIPickerView!
    var currentPicker : UITextField!
    
    // TODO: Cache this in a singleton so it doesn't need to reload every time this view initializes.
    var users = loadUsers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TEMP: If no users have been loaded, put some dummy data.
        if users.count == 0 {
            users = ["Joey", "Ally", "Kaylie", "Lisa", "Lo", "Wilene", "Bas"]
            writeUsers(users)
        }
        inputPlayer1.text = users[0]
        inputPlayer2.text = users[1]
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
            var gameViewController = segue.destinationViewController as GameViewController;
            gameViewController.user1 = "\(inputPlayer1!.text)"
            gameViewController.user2 = "\(inputPlayer2!.text)"
            
            // If the users didn't exist yet, add them and store. TODO: Move this to the users singleton?
            let currUsers = users.count
            if !contains(users, gameViewController.user1) { users.append(gameViewController.user1) }
            if !contains(users, gameViewController.user2) { users.append(gameViewController.user2) }
            if users.count > currUsers { writeUsers(users) }
        }
    }
    
    // Picker delegate methods.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(users[row])"
    }
    
    // When the picker closes set the text to the input field and hide it.
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        currentPicker.text = users[row]
        userPicker.hidden = true
    }
    
    // Hide picker when input field is focused.
    @IBAction func touchUpInside(sender: UITextField) {
        userPicker.hidden = true
    }
    
    // Show the username picker for player 1 and player 2.
    @IBAction func pickerUser1(sender: UIButton) {
        showPicker()
        currentPicker = inputPlayer1
    }
    @IBAction func pickerUser2(sender: UIButton) {
        showPicker()
        currentPicker = inputPlayer2
    }
    
    func showPicker() {
        self.view.endEditing(true)
        userPicker.hidden = false
    }
}

// TODO: Move to users singleton?
// Get the writable directory and path for the users file.
let writableDirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
let usersPath = writableDirs![0].stringByAppendingPathComponent("users")

// Read the users file and return them in an array of strings.
func loadUsers() -> [String] {
    if var text = String(contentsOfFile: usersPath, encoding: NSUTF8StringEncoding, error: nil) {
        return text.componentsSeparatedByString("\n")
    }
    return []
}

// Store users to the users file. Join them by line breaks.
func writeUsers(users: [String]) {
    "\n".join(users).writeToFile(usersPath, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
}
