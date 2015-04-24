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
    
    var game: GameModel
    var dictionary: DictionaryModel
    
//    var currChar : String!

    required init(coder aDecoder: NSCoder) {
        var user1 = "Ally"
        var user2 = "Joey"
        
        // DictionaryModel should throw an error when unable to load dictionary.
        dictionary = DictionaryModel(words: readDictionary()!)
        game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        
        super.init(coder: aDecoder)
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
        setCurrentPlayer(game.currentUser)
        
        labelUser1.text = game.user1
        labelUser2.text = game.user2
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
        
        inputWord.text = ""
        setReturnKeyType("Default")
        
        if let winner = game.winner() {
            // TEMP: Set current winners label
            var winnerLabel = winner ? labelUser1 : labelUser2
            
            winnerLabel.text = "winner: \(winnerLabel.text!)!"
        } else {
            setCurrentPlayer(game.currentUser)
        }
        return false;
    }
    
    func keyPressed(sender: NSNotification) {
        let l = countElements(inputWord.text)
//        var a : String
        if l >= 1 {
            var newChar = (inputWord.text as NSString).substringFromIndex(l - 1)
            inputWord.text = newChar
            currentWord.text = "\(game.currentWord)\(newChar)"
            setReturnKeyType("Go")
        } else {
            setReturnKeyType("Default")
            currentWord.text = game.currentWord
        }
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
    
    func setCurrentPlayer(turn: Bool) {
        // TODO: How to make DRY?
        if turn {
            labelUser2!.textColor = UIColor.blackColor()
            labelUser1!.textColor = UIColor.blueColor()
        } else {
            labelUser1!.textColor = UIColor.blackColor()
            labelUser2!.textColor = UIColor.blueColor()
        }
    }
}

func readDictionary() -> String? {
    let path = NSBundle.mainBundle().pathForResource("EnglishDictionary", ofType: "txt")
    
    return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
}