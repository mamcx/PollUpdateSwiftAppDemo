//
//  PollUpdateSwiftAppDemoTests.swift
//  PollUpdateSwiftAppDemoTests
//
//  Created by Mario Alejandro Montoya on 19/01/16.
//  Copyright © 2016 Mario Alejandro Montoya. All rights reserved.
//

import XCTest
@testable import PollUpdateSwiftAppDemo

class PollUpdateSwiftAppDemoTests: XCTestCase {
    let pathChoice = "programming-languages"
    let defaultChoice = "Swift"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testApiUrl() {
        XCTAssertEqual(Router.ListPolls.path, "/polls")
        XCTAssertEqual(Router.ListChoices(pathChoice).path, "/polls/\(pathChoice)/choices")
        XCTAssertEqual(Router.Upvote(pathChoice, 1).path, "/polls/\(pathChoice)/choices/1/upvotes")
    }

    func testGetPools() {
        ListPolls()
            .onSuccess{ polls in
                XCTAssertEqual(polls.count, 2)
                XCTAssertEqual(polls[0].id, self.pathChoice)
            }.onFailure {error in
                XCTFail(error.description)
        }
    }

    func testGetChoices() {
        ListChoises(pathChoice)
            .onSuccess{ choices in
                XCTAssertEqual(choices.count, 2)
                XCTAssertEqual(choices[0].choice, self.defaultChoice)
                XCTAssertEqual(choices[0].pollId, self.pathChoice)
            }.onFailure {error in
                XCTFail(error.description)
        }
    }

    func testGetUpvote() {
        let choice:Choice = Choice(
            id:1,
            pollId:pathChoice,
            choice:self.defaultChoice,
            votes:1
        )
        
        Upvote(choice.pollId, choiceId: choice.id)
            .onSuccess{ msg in
                XCTAssertEqual(msg, "Thank you!")
            }.onFailure {error in
                XCTFail(error.description)
        }
    }
}
