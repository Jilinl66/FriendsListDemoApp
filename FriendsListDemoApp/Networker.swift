//
//  Networker.swift
//  FriendsListDemoApp
//
//  Created by Jilin Liu on 12/13/17.
//  Copyright © 2017 Jilin Liu. All rights reserved.
//

import Foundation

class Networker {
    
    public static func networkAPICall(path: String, method: String, callback: @escaping (Int, AnyObject?, AnyObject?, String?) -> Void) {
        
        let headers = [
            "Authorization": "Bearer b3be6c0cbb0337a09307d79113fa7e7c695f5807",
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error fetching url" + path)
                callback(0, nil, nil, "\(String(describing: error))")
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if (statusCode >= 200 && statusCode <= 299) { //succeed
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            callback(statusCode, json as AnyObject, httpResponse.allHeaderFields as AnyObject, nil)
                        } catch {
                            callback(statusCode, data as AnyObject, nil, "Can't JSONify")
                        }
                    } else { // failed
                        callback(statusCode, response as AnyObject, httpResponse.allHeaderFields as AnyObject, "Error Serializing object with code \(statusCode)\npath: \(path)")
                    }
                }
            }
        })
        
        dataTask.resume()
    }
}
