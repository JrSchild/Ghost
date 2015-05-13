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
    
    let users = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputPlayer1.text = users.usernames[0]
        inputPlayer2.text = users.usernames[1]
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
            
            // If the users didn't exist yet, add them and store.
            users.addUserIfNotExists(gameViewController.user1)
            users.addUserIfNotExists(gameViewController.user2)
        } else if segue.identifier == "showHighscores" {
            (segue.destinationViewController as HighscoreViewController).users = users
        }
    }
    
    // Picker delegate methods.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.usernames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(users.usernames[row])"
    }
    
    // When the picker closes, set the text to the input field and hide it.
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        currentPicker.text = users.usernames[row]
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
        users.up(name)
    }
}