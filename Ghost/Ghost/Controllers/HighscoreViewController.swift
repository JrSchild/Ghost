//
//  HighscoreViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 11-05-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var mainViewController: MainViewController!
    let accessoryFontSize: CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainViewController.usernames.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let username = self.mainViewController.usernames[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(username)"
        
        // Create label for the score of user
        // Snippet partly from http://stackoverflow.com/a/29335837
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(accessoryFontSize)
        label.textAlignment = NSTextAlignment.Center
        label.text = "\(self.mainViewController.users[username]!)"
        label.sizeToFit()
        
        cell.accessoryView = label;
        
        return cell
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func clearHighscores(sender: AnyObject) {
        // TODO
    }
}
