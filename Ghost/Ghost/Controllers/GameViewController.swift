//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//
//  Controls the flow of one entire game. Uses a GameModel instance to store the data.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var labelUser1: UILabel!
    @IBOutlet weak var labelUser2: UILabel!
    @IBOutlet weak var inputWord: UITextField!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var scoreUser1Label: UILabel!
    @IBOutlet weak var scoreUser2Label: UILabel!
    
    var dictionary: DictionaryModel!
    var game: GameModel!
    var mainViewController: MainViewController!
    var user1: String!
    var user2: String!
    let userTurn = UIColor.blueColor()
    let userNotTurn = UIColor.blackColor()
    
    // Validate the input, if no char is entered yet validate first char, otherwise both.
    let inputTest = NSPredicate(format: "SELF MATCHES %@", "^[\'a-z-]{0,1}[\'a-z-]{1}$")
    
    // Pass currentGame from parent-controller if it has to start an existing game.
    var currentGame: [String:AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDictionaryModel()
        
        // If the mainViewController passed through an existing game, restore it, otherwise instantiate new.
        if currentGame != nil {
            game = GameStorage.restore(dictionary, gameData: currentGame!)
        } else {
            game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        }
        
        // Remove cursor, set delegate of inputword, set usernames and start.
        inputWord.tintColor = UIColor.clearColor()
        inputWord.delegate = self
        labelUser1.text = user1
        labelUser2.text = user2
        start()
    }
    
    // Start a game.
    func start() {
        
        // Update values and focus the input so keyboard shows.
        currentWord.text = game.round.currentWord
        setCurrentPlayer()
        setScore()
        inputWord.resignFirstResponder()
        inputWord.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if countElements(inputWord.text) != 1 {
            return false
        }
        
        // Guess current letter, update currentWord, reset input and auto-disable GO button.
        game.guess(inputWord.text)
        currentWord.text = game.round.currentWord
        inputWord.text = ""
        inputWord.resignFirstResponder()
        inputWord.becomeFirstResponder()
        
        // If there's a winner check if the game has ended otherwise change current player.
        if let winner = game.roundWinner() {
            setScore()
            
            // If score is higher than current letters in final word, finish game and dismiss ViewController
            if let gameWinner = game.isGameOver() {
                mainViewController.winner(gameWinner)
                dismissViewControllerAnimated(false, completion: nil)
                
            // Otherwise swap the beginning user and start a new round.
            } else {
                game.newRound()
                start()
            }
        } else {
            setCurrentPlayer()
        }
        
        return false
    }
    
    @IBAction func keyPressed() {
        var l = countElements(inputWord.text)
        let inputChar = inputWord.text.lowercaseString
        
        // If input passes, use the last character.
        if inputTest!.evaluateWithObject(inputChar) {
            inputWord.text = (inputChar as NSString).substringFromIndex(l - 1)
            
        // Else if there already was a char entered, use that one, otherwise clear it.
        } else if l >= 1 {
            inputWord.text = (inputChar as NSString).substringWithRange(NSRange(location: 0, length: l == 1 ? 0 : 1))
        }
        
        // Set the current word. Color the entered input red.
        let attributedText = NSMutableAttributedString(string: "\(game.round.currentWord)\(inputWord.text)")
        l = attributedText.length
        if l > countElements(game.round.currentWord) {
            attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSRange(location: l - 1, length: 1))
        }
        currentWord.attributedText = attributedText
    }
    
    // Update score in view. Substring the final word with the score of each user.
    func setScore() {
        scoreUser1Label.text = getScoreText(game.scoreUser1)
        scoreUser2Label.text = getScoreText(game.scoreUser2)
    }
    
    // Set the color of each player depending on who's turn it is.
    func setCurrentPlayer() {
        let turn = game.round.currentUser
        
        labelUser1.textColor = turn ? userTurn : userNotTurn
        labelUser2.textColor = turn ? userNotTurn : userTurn
    }
    
    // Return the text of the score of user. e.g. 3 returns GHO
    func getScoreText(scoreUser: Int) -> String {
        return game.finalWord.substringWithRange(Range(start: game.finalWord.startIndex, end: advance(game.finalWord.startIndex, scoreUser)))
    }
    
    func loadDictionaryModel() {
        dictionary = DictionaryModel(words: DictionaryStorage.load(mainViewController.languages.language)!)
    }
    
    @IBAction func showOptions() {
        let sheet: UIActionSheet = UIActionSheet();
        sheet.delegate = self;
        sheet.addButtonWithTitle("Restart game")
        sheet.addButtonWithTitle("Exit game")
        
        // Only show the language(s) that are not the current language.
        let languages = mainViewController.languages.languages.filter { $0 != self.mainViewController.languages.language }
        for language in languages {
            sheet.addButtonWithTitle(language)
        }
        sheet.addButtonWithTitle("Cancel");
        sheet.cancelButtonIndex = languages.count + 2;
        sheet.showInView(view);
    }
    
    // Callback for action sheet.
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        
        // If user wants to restart game.
        if buttonIndex == 0 {
            restart()
            
        // If user wants to exit game.
        } else if buttonIndex == 1 {
            game.destroy()
            dismissViewControllerAnimated(false, completion: nil)
            
        // If chosen option is language.
        } else if let languageIndex = find(mainViewController.languages.languages, sheet.buttonTitleAtIndex(buttonIndex)) {
            mainViewController.languages.setLanguage(languageIndex)
            loadDictionaryModel()
            restart()
        }
    }
    
    func restart() {
        game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        start()
    }
}
