//
//  HighscoreViewController.swift
//  Ghost
//
//  Created by Joram Ruitenschild on 11-05-15.
//  Copyright (c) 2015 Joram Ruitenschild - 500627061. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users: UserModel!
    let accessoryFontSize: CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Return length of content.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.usernames.count;
    }
    
    // Return table-cell per content item.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let username = users.usernames[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(username)"
        
        // Create label for the score of user
        // Snippet partly from http://stackoverflow.com/a/29335837
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(accessoryFontSize)
        label.textAlignment = NSTextAlignment.Center
        label.text = "\(users.users[username]!)"
        label.sizeToFit()
        
        cell.accessoryView = label;
        
        return cell
    }
    
    // Make sure headerbar lays under statusbar.
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func clearHighscores(sender: UIBarButtonItem) {
        let sheet: UIActionSheet = UIActionSheet();
        sheet.delegate = self;
        sheet.addButtonWithTitle("Clear scores");
        sheet.addButtonWithTitle("Clear users");
        sheet.addButtonWithTitle("Cancel");
        sheet.cancelButtonIndex = 2;
        sheet.showInView(self.view);
    }
    
    // Callback for action sheet.
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            users.clearScore()
        } else if buttonIndex == 1 {
            users.clearUsers()
        }
        self.tableView.reloadData()
    }
}
