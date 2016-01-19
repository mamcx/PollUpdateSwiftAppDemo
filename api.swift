//
//  api.swift
//  PollUpdateSwiftAppDemo
//
//  Created by Mario Alejandro Montoya on 19/01/16.
//  Copyright © 2016 Mario Alejandro Montoya. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures
import SwiftyJSON

enum Router: URLRequestConvertible {
    //TODO: Currently only the mockup end-pint work
    static let baseURLString = "http://private-anon-9763818b2-mobilitypt.apiary-mock.com"
    //static let baseURLString = "http://polls.apiblueprint.org/"
    
    case ListPolls
    case ListChoices(String)
    case Upvote(String, Int)
   
    var method: Alamofire.Method {
        switch self {
        case .ListPolls:
            return .GET
        case .ListChoices:
            return .GET
        case .Upvote:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .ListPolls:
            return "/polls"
        case .ListChoices(let pollId):
            return "/polls/\(pollId)/choices"
        case .Upvote(let pollId, let choiceId):
            return "/polls/\(pollId)/choices/\(choiceId)/upvotes"
        }
    }
    
    // MARK: URLRequestConvertible
    // Auto-build the corret URL + METHOD
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))

        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.HTTPMethod = method.rawValue
        print("Calling \(method.rawValue): \(mutableURLRequest.URLString)")
        return mutableURLRequest
    }
}

// Generic fetcher. It turn the async call into a promise to allow
// easier interface and reduce callback-hell
func request(route:Router) ->  Future<JSON, NSError> {
    let promise = Promise<JSON, NSError>()
    
    Alamofire.request(route)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            
            switch response.result {
            case .Success:
                let json = JSON(data:response.data!)
                
                if json.error != nil {
                    promise.failure(json.error!)
                } else {
                    promise.success(json)
                }
                
            case .Failure(let error):
                print(error)
                promise.failure(error)
            }
    }
    
    return promise.future
}

func ListPolls() -> Future< Array<Poll>, NSError> {
    let promise = Promise< Array<Poll>, NSError>()
    
    request(Router.ListPolls)
        .onSuccess{ json in
            var rows = Array<Poll>()
            
            for (_, subJson):(String, JSON) in json {
                let p = Poll(
                    id:subJson["id"].string!,
                    title:subJson["title"].string!
                )
                rows.append(p)
            }
            
            promise.success(rows);
        }.onFailure { error in
            promise.failure(error)
    }
    
    return promise.future
}

func ListChoises(pollId:String) -> Future< Array<Choice>, NSError> {
    let promise = Promise< Array<Choice>, NSError>()
    
    request(Router.ListChoices(pollId))
        .onSuccess{ json in
            var rows = Array<Choice>()
            
            for (_, subJson):(String, JSON) in json {
                let p = Choice(
                    id:subJson["id"].int!,
                    pollId:pollId,
                    choice:subJson["choice"].string!,
                    votes:subJson["votes"].int32!
                )
                rows.append(p)
            }
            
            promise.success(rows);
        }.onFailure { error in
            promise.failure(error)
    }
    
    return promise.future
}

func Upvote(pollId:String, choiceId:Int) -> Future<String, NSError> {
    let promise = Promise<String, NSError>()
    
    request(Router.Upvote(pollId, choiceId))
        .onSuccess{ json in
            promise.success(json["greeting"].string!);
        }.onFailure { error in
            promise.failure(error)
    }
    
    return promise.future
}
