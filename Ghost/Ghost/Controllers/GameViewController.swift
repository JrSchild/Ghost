//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelUser1: UILabel!
    @IBOutlet weak var labelUser2: UILabel!
    @IBOutlet weak var inputWord: UITextField!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var scoreUser1Label: UILabel!
    @IBOutlet weak var scoreUser2Label: UILabel!
    
    let dictionary: DictionaryModel
    var game: GameModel!
    var user1 : String!
    var user2 : String!
    var scoreUser1 = 0
    var scoreUser2 = 0
    let inputTest = NSPredicate(format:"SELF MATCHES %@", "^[\'a-z-]{0,1}[\'a-z-]{1}$")
    let finalWord = "GHOST"
    
    // Indicates which user starts the next round
    private var userStart = true
    
    required init(coder aDecoder: NSCoder) {
        
        // DictionaryModel should throw an error when unable to load dictionary.
        dictionary = DictionaryModel(words: readDictionary()!)
        
        super.init(coder: aDecoder)
    }
    
    func start() {
        inputWord.text = ""
        currentWord.text = ""
        game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        game.currentUser = userStart
        setCurrentPlayer(game.currentUser)
        setScore()
    }
    
    //    // Might not be necessary
    //    deinit {
    //        inputWord.resignFirstResponder()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputWord.tintColor = UIColor.clearColor()
        inputWord.autocorrectionType = UITextAutocorrectionType.No
        inputWord.delegate = self
        inputWord.addTarget(self, action: "keyPressed:", forControlEvents: UIControlEvents.EditingChanged)
        setReturnKeyType("Default")
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
        
        game.guess(inputWord.text)
        currentWord.text = game.currentWord
        setReturnKeyType("Default")
        
        if let winner = game.winner() {
            var score : Int
            if winner {
                score = ++scoreUser2
            } else {
                score = ++scoreUser1
            }
            
            setScore()
            if score >= countElements(finalWord) {
                println("GAME OVER")
                let refreshAlert = UIAlertView()
                refreshAlert.title = "GAME OVER"
                refreshAlert.addButtonWithTitle("OK")
                refreshAlert.show()
            }
            
            userStart = !userStart
            start()
        } else {
            setCurrentPlayer(game.currentUser)
        }
        return false
    }
    
    func keyPressed(sender: NSNotification) {
        var l = countElements(inputWord.text)
        let inputChar = inputWord.text.lowercaseString
        
        if inputTest!.evaluateWithObject(inputChar) {
            inputWord.text = (inputChar as NSString).substringFromIndex(l - 1)
        } else if l >= 1 {
            inputWord.text = (inputChar as NSString).substringWithRange(NSRange(location: 0, length: l == 1 ? 0 : 1))
        }
        setReturnKeyType("Auto")
        
        let attributedText = NSMutableAttributedString(string: "\(game.currentWord)\(inputWord.text)")
        
        l = attributedText.length
        if l > countElements(game.currentWord) {
            attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSRange(location: l - 1, length: 1))
        }
        currentWord.attributedText = attributedText
    }
    
    func setReturnKeyType(type: String) {
        if type == "Go" {
            inputWord.returnKeyType = UIReturnKeyType.Go
        } else if type == "Default" {
            inputWord.returnKeyType = UIReturnKeyType.Default
        } else if type == "Auto" {
            // Set type based on input.
            if countElements(inputWord.text) > 0 {
                return setReturnKeyType("Go")
            }
            return setReturnKeyType("Default")
        }
        
        inputWord.resignFirstResponder()
        inputWord.becomeFirstResponder()
    }
    
    // TODO: Make DRY
    func setScore() {
        scoreUser1Label.text = finalWord.substringWithRange(Range(start: finalWord.startIndex, end: advance(finalWord.startIndex, scoreUser1)))
        scoreUser2Label.text = finalWord.substringWithRange(Range(start: finalWord.startIndex, end: advance(finalWord.startIndex, scoreUser2)))
    }
    
    func setCurrentPlayer(turn: Bool) {
        labelUser1.textColor = turn ? UIColor.blueColor() : UIColor.blackColor()
        labelUser2.textColor = turn ? UIColor.blackColor() : UIColor.blueColor()
    }
}

func readDictionary() -> String? {
    let path = NSBundle.mainBundle().pathForResource("english", ofType: nil)
    
    return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
}