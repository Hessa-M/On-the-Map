//
//  APIConnect.swift
//  On the Map
//
//  Created by Hessa Mohamed on 29/12/2018.
//  Copyright © 2018 Hessa Mohamed. All rights reserved.
//

import Foundation

class UdacityAPI {
   
    private static var userInfo = UserInfo()

    static let urlString = "https://onthemap-api.udacity.com/v1/session"

    static func login (_ username : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion (false, "", error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (false, "", statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                
                let loginDictionary = loginJsonObject as? [String : Any]
                
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]

                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                self.userInfo.key = uniqueKey
                completion (true, self.userInfo.key!, nil)
            } else {
                completion (false, "", nil)
            }
        }
        task.resume()
    }

    static func getUserInfo(_ completion: @escaping (UserInfo? ,Error?)->()) {

        let url = URL(string: "https://onthemap-api.udacity.com/v1/users/" + self.userInfo.key!)
        var request = URLRequest(url: url!)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                
                 let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
   
                let userDictionary = loginJsonObject as? [String : Any]
          
                self.userInfo.firstName = userDictionary?["first_name"] as? String
                self.userInfo.lastName = userDictionary?["last_name"] as? String
  
                completion(self.userInfo, nil)
            } else{
                //out of range
                let statusOutOfRangeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, statusOutOfRangeError)
                return
            }
        }
        task.resume()
    }
    
  static func logout(completion: @escaping (Bool, Error?)->()) {
        
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion (false,error)
                return
            }
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {
                
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (false, statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                
                completion (true, nil)
            }else{
                completion (false, nil)
                return
            }
        }
        task.resume()
    }
        
}

