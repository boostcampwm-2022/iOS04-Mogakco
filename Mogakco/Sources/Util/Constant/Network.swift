//
//  Network.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/30.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

enum Network {
    static let baseURLString: String = "https://firestore.googleapis.com/v1/projects/mogakco-69b97/databases/(default)"
    static let authBaseURLString: String = "https://identitytoolkit.googleapis.com/v1"
    static let webAPIKey: String = "AIzaSyDZYeWGCGv_NZpqRrTiKfmlqbPD9nIGzJk"
    static let fcmAPIKey: String = "AAAA6-cpVGg:APA91bHWQzHyJQspWpt1C3Mjm0M9ACaa4rw6LlL2kYPM_f41vEtb50fcUQY6QAX8a3CsRG28MVFgt2JFocl1TIpVyKq-gBIolEKIb55ahvpcopf2mcBNGR38jBRrBWqK19sj1Me9RGJJ"
    static let fcmBaseURLStirng: String = "https://fcm.googleapis.com/fcm"
    static let servicePolicyURLString: String = "https://complete-health-026.notion.site/28fa997c334b4442b4af9d87174df248"
    static let contentPolicyURLString: String = "https://complete-health-026.notion.site/93c1f73ed6414d78a7aaaeb4fe9446ad"
}
