//
//  DetailViewController.swift
//  PollUpdateSwiftAppDemo
//
//  Created by Mario Alejandro Montoya on 19/01/16.
//  Copyright © 2016 Mario Alejandro Montoya. All rights reserved.
//

import UIKit
import GSMessages

class DetailViewController: UITableViewController {
    var objects = Array<Choice>()


    var detailItem: Poll? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func loadChoices(pollId:String) {
        ListChoises(pollId)
            .onSuccess{ choices in
                self.objects = choices
                self.tableView.reloadData()
            }.onFailure {error in
                self.showMessage(error.description, type: .Error, options: [.Height(80), .TextNumberOfLines(6)])
        }
        
    }
    
    @IBAction func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            let poll = detail as Poll
            self.title = poll.title
            loadChoices(poll.id)
        }
    }

    func upvote(sender: UIButton!) {
        let choice = objects[sender.tag]
        
        Upvote(choice.pollId, choiceId: choice.id)
            .onSuccess{msg in
                self.loadChoices(choice.pollId) //TODO: The mock server not update the count!
                self.showMessage(msg, type: .Success, options: nil)
            }.onFailure {error in
                self.showMessage(error.description, type: .Error, options: [.Height(80), .TextNumberOfLines(6)])
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ChoiceCellTableViewCell
        
        let choice = objects[indexPath.row]
        
        cell.titleLabel.text = choice.choice
        cell.subtitleLabel.text = "\(choice.votes) votes"
        cell.upvoteButton.tag = indexPath.row
        cell.upvoteButton.addTarget(self, action: "upvote:", forControlEvents: .TouchUpInside)
        
        return cell
    }
}



