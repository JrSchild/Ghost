//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelUser1: UILabel!
    @IBOutlet weak var labelUser2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var user1 = "Ally"
        var user2 = "Joey"
        
        // Should throw an error when unable to load dictionary.
        var dictionary = DictionaryModel(words: readDictionary()!)
        var game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        
        labelUser1.text = user1
        labelUser2.text = user2
        
        // Exactly one letter must be guessed.
        game.guess("a")
        game.guess("b")
        game.guess("o")
        
        game = GameModel(dictionary: dictionary, user1: user1, user2: user2)
        game.guess("a")
        game.guess("b")
        game.guess("o")
        game.guess("v")
        println(game.winner())
        game.guess("e")
        println(game.winner())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func readDictionary() -> String? {
    let path = NSBundle.mainBundle().pathForResource("EnglishDictionary", ofType: "txt")
    
    return String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
}