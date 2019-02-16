//
//  ParseAPI.swift
//  On the Map
//
//  Created by Hessa Mohamed on 12/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import Foundation

class ParseAPI{
    
    static let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let contentType="application/json"

    static func getStudentLocations (completion: @escaping (StudentLocationData?, Error?) -> ()) {
        
        let urlGetLocation = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        
        let url = URL(string: urlGetLocation)
        print("url: \(url!)")
        var request = URLRequest(url: url!)
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            if error != nil {
                print("Error get student location")
                completion (nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode
            else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                var studentLocations: [StudentLocationInfo] = []

                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                for location in resultsArray! {
                    let data = try! JSONSerialization.data(withJSONObject: location)
                    let studentLocation = try! JSONDecoder().decode(StudentLocationInfo.self, from: data)
                    studentLocations.append(studentLocation)
                }
                completion (StudentLocationData(studentLocations: studentLocations), nil)
            }else{
                //out of range
                let statusOutOfRangeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, statusOutOfRangeError)
                return
            }
        }
        
        task.resume()
    }
    
    static func postStudentLocations (newMapString: String,newMediaURL:String,newLatitude: Double, newLongitude:Double,uniqueKey: String ,firstName: String ,lastName: String ,completion: @escaping (Error?) -> ())-> URLSessionDataTask {

        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\":  \"\(newMapString)\", \"mediaURL\": \"\(newMediaURL)\",\"latitude\": \(newLatitude), \"longitude\":  \(newLongitude)}"

        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod="POST"
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)

        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            if error != nil {
                completion (error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    
                    completion ( statusCodeError)
                    return
            }
            
            if statusCode >= 200 && statusCode < 300 {
              /*  let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array = resultsArray else {return}
                
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                
                let studentsLocations = try! JSONDecoder().decode([StudentLocationInfo].self, from: dataObject)
                */
                completion (nil)
            }else{
                //out of range
                let statusOutOfRangeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (statusOutOfRangeError)
                return
            }
        }
        
        task.resume()
        return task
    }
}
