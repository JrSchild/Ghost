//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelUser1 : UILabel!
    @IBOutlet weak var labelUser2 : UILabel!
    @IBOutlet weak var inputWord : UITextField!
    @IBOutlet weak var currentWord : UILabel!
    @IBOutlet weak var scoreUser1Label : UILabel!
    @IBOutlet weak var scoreUser2Label : UILabel!
    
    let dictionary : DictionaryModel
    var game : GameModel!
    var mainViewController : MainViewController!
    var user1 : String!
    var user2 : String!
    var scoreUser1 = 0
    var scoreUser2 = 0
    let finalWord = "GHOST"
    let userTurn = UIColor.blueColor()
    let userNotTurn = UIColor.blackColor()
    
    // Validate the input, if no char is entered yet validate first char, otherwise both.
    let inputTest = NSPredicate(format:"SELF MATCHES %@", "^[\'a-z-]{0,1}[\'a-z-]{1}$")
    
    // Indicates which user starts the next round
    var userStart = true
    
    required init(coder aDecoder: NSCoder) {
        
        // DictionaryModel should throw an error when unable to load dictionary.
        dictionary = DictionaryModel(words: readDictionary()!)
        
        super.init(coder: aDecoder)
    }
    
    // Reset all variables, create and start a new game.
    func start() {
        inputWord.text = ""
        currentWord.text = ""
        game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        game.currentUser = userStart
        inputWord.becomeFirstResponder()
        setCurrentPlayer(game.currentUser)
        setScore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove cursor, set delegate of inputword, set usernames and start.
        inputWord.tintColor = UIColor.clearColor()
        inputWord.delegate = self
        labelUser1.text = user1
        labelUser2.text = user2
        start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if countElements(inputWord.text) != 1 {
            return false
        }
        
        // Guess current letter, update currentWord, reset input and auto-disable GO button.
        game.guess(inputWord.text)
        currentWord.text = game.currentWord
        inputWord.text = ""
        inputWord.resignFirstResponder()
        inputWord.becomeFirstResponder()
        
        // If there's a winner check if the game has ended otherwise change current player.
        if let winner = game.winner() {
            
            // One-up score of loser and update view.
            var score : Int
            if winner {
                score = ++scoreUser2
            } else {
                score = ++scoreUser1
            }
            setScore()
            
            // If score is higher than current letters in final word, finish game and dismiss ViewController
            if score >= countElements(finalWord) {
                self.mainViewController.winner(winner ? user1 : user2)
                self.dismissViewControllerAnimated(false, completion: nil)
            
            // Otherwise swap the beginning user and start a new round.
            } else {
                userStart = !userStart
                start()
            }
        } else {
            setCurrentPlayer(game.currentUser)
        }
        return false
    }
    
    @IBAction func keyPressed(sender: UITextField) {
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
        let attributedText = NSMutableAttributedString(string: "\(game.currentWord)\(inputWord.text)")
        l = attributedText.length
        if l > countElements(game.currentWord) {
            attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSRange(location: l - 1, length: 1))
        }
        currentWord.attributedText = attributedText
    }
    
    // TODO: Make DRY?
    // Update score in view. Substring the final word with the score of each user.
    func setScore() {
        scoreUser1Label.text = finalWord.substringWithRange(Range(start: finalWord.startIndex, end: advance(finalWord.startIndex, scoreUser1)))
        scoreUser2Label.text = finalWord.substringWithRange(Range(start: finalWord.startIndex, end: advance(finalWord.startIndex, scoreUser2)))
    }
    
    // Set the color of each player depending on who's turn it is.
    func setCurrentPlayer(turn: Bool) {
        labelUser1.textColor = turn ? userTurn : userNotTurn
        labelUser2.textColor = turn ? userNotTurn : userTurn
    }
}

// Read the dictionary and return its contents.
func readDictionary() -> String? {
    let path = NSBundle.mainBundle().pathForResource("english", ofType: nil)
    
    return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
}