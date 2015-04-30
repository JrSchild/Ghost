//
//  MainViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 30-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var inputPlayer1: UITextField!
    @IBOutlet weak var inputPlayer2: UITextField!
    @IBOutlet weak var userPicker: UIPickerView!
    var currentPicker : UITextField!
    
    let users = ["Joey", "Ally", "Kaylie", "Lisa", "Lo", "Wilene", "Bas"]
    
    @IBAction func pickerUser1(sender: UIButton) {
        showPicker()
        currentPicker = inputPlayer1
    }
    
    @IBAction func pickerUser2(sender: UIButton) {
        showPicker()
        currentPicker = inputPlayer2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if segue.identifier == "startGame" {
            var gameViewController = segue.destinationViewController as GameViewController;
            gameViewController.user1 = "\(inputPlayer1!.text)"
            gameViewController.user2 = "\(inputPlayer2!.text)"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(users[row])"
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        currentPicker.text = users[row]
        userPicker.hidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        userPicker.hidden = false
        return false
    }
    
    func showPicker() {
        self.view.endEditing(true)
        userPicker.hidden = false
    }
}
