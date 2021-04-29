//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Roy Park on 4/28/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    init() {}

}
// MARK: - Account Management

extension DatabaseManager {
    
    enum DatabaseError: Error {
        case emailExistInDatabase
    }
    


    
    /// Check if you can create the new user with
    /// - Parameters:
    ///   - email: present String
    ///   - completion: callback function return Bool
    public func canCreateNewUser(
        with email: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "$", with: "-")
            
        database.child("email").observeSingleEvent(of: .value) { snapshot in
            guard !snapshot.exists() else {
                // we found the email so can't create the account
                completion(.failure(DatabaseError.emailExistInDatabase))
                return
            }
            
            // there is no same email address, so you can create
            completion(.success(email))
        }
//        database.child("email").observeSingleEvent(of: .value) { snapshot in
//            guard snapshot.value as? String == nil else {
//                // we found the email so can't create the account
//                completion(.failure(DatabaseError.emailExistInDatabase))
//                return
//            }
//
//            // there is no same email address, so you can create
//            completion(.success(true))
//        }
    }

    
    /// Insert new user to the database
    /// - Parameter user: ChatAppUser
    public func insertUser(
        with user: ChatAppUser,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
        print("Inserted the user into firebase successfully")
        completion(.success(user.email))
    }
}


