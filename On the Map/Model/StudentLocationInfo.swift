//
//  StudentLocation.swift
//  On the Map
//
//  Created by Hessa Mohamed on 01/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import Foundation

struct StudentLocationInfo: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
}

extension StudentLocationInfo {
    init?(dictionary: [String:Any]){
        self.createdAt = dictionary["createdAt"] as?  String
        self.firstName = dictionary["firstName"] as?  String
        self.lastName = dictionary["lastName"] as?  String
        self.latitude = dictionary["latitude"] as?  Double
        self.longitude = dictionary["longitude"] as?  Double
        self.mapString = dictionary["mapString"] as?  String
        self.mediaURL = dictionary["mediaURL"] as?  String
        self.objectId = dictionary["objectId"] as?  String
        self.uniqueKey = dictionary["uniqueKey"] as?  String
        self.updatedAt = dictionary["updatedAt"] as?  String
    }
    
    struct newStudentLocation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
}
