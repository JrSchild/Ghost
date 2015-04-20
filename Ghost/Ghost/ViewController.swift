//
//  ViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 16-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Should throw an error when unable to load dictionary.
        var dictionary = DictionaryModel(words: readDictionary()!)
        var game = GameModel(dictionary: dictionary)
        
        // Exactly one letter must be guessed.
        game.guess("a")
        game.guess("b")
        game.guess("o")
        
        game = GameModel(dictionary: dictionary)
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