//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelUser1: UILabel!
    @IBOutlet weak var labelUser2: UILabel!
    @IBOutlet weak var inputWord: UITextField!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var scoreUser1Label: UILabel!
    @IBOutlet weak var scoreUser2Label: UILabel!
    
    var dictionary: DictionaryModel
    var game: GameModel!
    var user1 = "Ally"
    var user2 = "Joey"
    var scoreUser1 = 0
    var scoreUser2 = 0
    let finalWord = "GHOST"
    
    // Indicates which user starts the next round
    var userStart = true
    
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
                var refreshAlert = UIAlertView()
                refreshAlert.title = "GAME OVER"
                refreshAlert.addButtonWithTitle("OK")
                refreshAlert.show()
            }
            
            userStart = !userStart
            start()
        } else {
            setCurrentPlayer(game.currentUser)
        }
        return false;
    }
    
    func keyPressed(sender: NSNotification) {
        var l = countElements(inputWord.text)
        var attributedText : NSMutableAttributedString
        
        if l >= 1 {
            inputWord.text = (inputWord.text as NSString).substringFromIndex(l - 1)
            setReturnKeyType("Go")
        } else {
            setReturnKeyType("Default")
        }
        
        attributedText = NSMutableAttributedString(string: "\(game.currentWord)\(inputWord.text)")
        
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
    let path = NSBundle.mainBundle().pathForResource("EnglishDictionary", ofType: "txt")
    
    return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
}