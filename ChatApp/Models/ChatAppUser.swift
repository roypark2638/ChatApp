//
//  ChatAppUser.swift
//  ChatApp
//
//  Created by Roy Park on 4/28/21.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let email: String
//    let profilePictureURL: String
    
    var safeEmail: String {
        return email.replacingOccurrences(of: ".", with: "-")
    }
}
