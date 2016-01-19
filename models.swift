//
//  models.swift
//  PollUpdateSwiftAppDemo
//
//  Created by Mario Alejandro Montoya on 19/01/16.
//  Copyright © 2016 Mario Alejandro Montoya. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

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

func randomInt(min:Int32, max:Int32) ->Int32 {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

/*func fakeString(values:Array<String>) -> Array<String> {
    
}


func buildFakePolls(total: Int32) ->Array<Poll> {
    
}*/