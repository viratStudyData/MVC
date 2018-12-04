//
//  APIHandler.swift
//  TestVirat
//
//  Created by cbl16 on 7/27/18.
//  Copyright © 2018 Codebrew. All rights reserved.
//

import UIKit

class APIHandler: NSObject {
    
    
    class func callPost(url:String, params:[String:Any], success:@escaping ([String: AnyObject])->(), failure: @escaping (String) -> ())
    {
        let urlStr = NSURL(string: url)
        var request = URLRequest(url: urlStr! as URL)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                failure(error!.localizedDescription)
            }else {
                do
                {
                    if let jsonData = data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        DispatchQueue.main.async(execute: {
                            success(parsedData as! [String: AnyObject])
                        })
                    }
                } catch {
                    failure("Parse Error: \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
    }
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    
    
}
