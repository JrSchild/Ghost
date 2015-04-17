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
        var game = GameModel()
        game.guess("a")
        game.guess("")
        game.guess("bla")
        game.guess("opa")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

