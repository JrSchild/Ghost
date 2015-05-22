//
//  MainViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 30-04-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var inputPlayer1: UITextField!
    @IBOutlet weak var inputPlayer2: UITextField!
    @IBOutlet weak var pickerPlayer1: UIButton!
    @IBOutlet weak var pickerPlayer2: UIButton!
    @IBOutlet weak var userPicker: UIPickerView!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var pickerLanguage: UIButton!
    
    var currentPicker: UITextField!
    var currentGame: [String:AnyObject]!
    
    let users = UserModel()
    let languages = LanguageModel()
    
    required init(coder aDecoder: NSCoder) {
        currentGame = GameStorage.load()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputPlayer1.text = users.usernames[0]
        inputPlayer2.text = users.usernames[1]
        
        pickerLanguage.setTitle(languages.language, forState: UIControlState.Normal)
        languagePicker.selectRow(find(languages.languages, languages.language)!, inComponent: 0, animated: false)
    }
    
    // If a game is already created, start the current game when the view appears.
    override func viewDidAppear(animated: Bool) {
        if currentGame != nil {
            self.performSegueWithIdentifier("startGame", sender: nil)
        }
    }

    // Un-focus the textfield when tapped outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        userPicker.hidden = true
        languagePicker.hidden = true
    }
    
    // When moving away from current view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // A game starts: set the input of the player names to the new GameViewController.
        if segue.identifier == "startGame" {
            var gameViewController = segue.destinationViewController as GameViewController
            gameViewController.user1 = "\(inputPlayer1!.text)"
            gameViewController.user2 = "\(inputPlayer2!.text)"
            gameViewController.mainViewController = self
            gameViewController.currentGame = currentGame
            currentGame = nil
            
            // If the users didn't exist yet, add them and store.
            users.addUserIfNotExists(gameViewController.user1)
            users.addUserIfNotExists(gameViewController.user2)
        
        // Showing highscores, set users model to target controller.
        } else if segue.identifier == "showHighscores" {
            (segue.destinationViewController as HighscoreViewController).users = users
        }
    }
    
    
    // Hide picker when input field is focused.
    @IBAction func touchDown() {
        userPicker.hidden = true
        languagePicker.hidden = true
    }
    
    // Show the username picker for player 1 and player 2.
    @IBAction func showPicker(sender: UIButton) {
        currentPicker = sender == pickerPlayer1 ? inputPlayer1 : inputPlayer2
        
        self.view.endEditing(true)
        userPicker.hidden = false
        if let index = find(users.usernames, currentPicker.text) {
            userPicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        languagePicker.hidden = true
    }
    
    // Show language picker
    @IBAction func showLanguage() {
        self.view.endEditing(true)
        userPicker.hidden = true
        languagePicker.hidden = false
    }
    
    // If there is a winner
    func winner(name: String) {
        
        // Show an alert with information.
        let refreshAlert = UIAlertView()
        refreshAlert.title = "GAME OVER \(name) Won"
        refreshAlert.addButtonWithTitle("OK")
        refreshAlert.show()
        
        // Up the score of the winner with one, and save it.
        users.up(name)
    }
}

// Implement PickerView protocols outside of MainViewController
extension MainViewController: UIPickerViewDelegate {
    
    // Return the content of each pickerview-row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 0 {
            return "\(users.usernames[row])"
        } else if pickerView.tag == 1 {
            return languages.languages[row]
        }
        return ""
    }
    
    // When the picker closes
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        
        // Userpicker: set the text to the input field and hide it.
        if pickerView.tag == 0 {
            if users.usernames.count > row {
                currentPicker.text = users.usernames[row]
            }
            userPicker.hidden = true
            
        // Languagepicker: update button title and set the new language.
        } else if pickerView.tag == 1 {
            pickerLanguage.setTitle(languages.languages[row], forState: UIControlState.Normal)
            languages.setLanguage(languages.languages[row])
            languagePicker.hidden = true
        }
    }
}

extension MainViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Return the length of each pickerview.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return users.usernames.count
        } else if pickerView.tag == 1 {
            return languages.languages.count
        }
        return 0
    }
}
