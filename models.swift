//
//  models.swift
//  PollUpdateSwiftAppDemo
//
//  Created by Mario Alejandro Montoya on 19/01/16.
//  Copyright © 2016 Mario Alejandro Montoya. All rights reserved.
//

import Foundation

struct Poll {
    let id: String
    let title: String
    
    func summary() -> String {
        return "\(id): \(title)"
    }
}

struct Choice {
    let id: Int
    let pollId: String
    let choice: String
    let votes: Int32
    
    func summary() -> String {
        return "\(id): \(choice) with \(votes) votes"
    }
}
