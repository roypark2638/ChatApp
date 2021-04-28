//
//  AuthManager.swift
//  ChatApp
//
//  Created by Roy Park on 4/28/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    init() {}
    
    private let auth = Auth.auth()
    
    enum AuthError: Error {
        case creatingUserError
        case signingInUserError
    }
    
    // MARK: - Public
    
    public func isSignedIn() -> Bool {
        print("\ncurrently the user is signed in : \(auth.currentUser != nil)\n")
        return auth.currentUser != nil
    }
    
    public func createUser(
        with firstName: String,
        lastName: String,
        email: String,
        password: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        DatabaseManager.shared.canCreateNewUser(with: email) { [weak self] result in
            switch result {
            case .success:
                self?.auth.createUser(
                    withEmail: email, password: password) { result, error in
                    guard result != nil, error == nil else {
                        if error != nil {
                            completion(.failure(error!))
                        }
                        else {
                            completion(.failure(AuthError.creatingUserError))
                        }
                        
                        return
                    }
                    
                    DatabaseManager.shared.insertUser(with: ChatAppUser(
                                                        firstName: firstName,
                                                        lastName: lastName,
                                                        email: email))

                    
                }
            case .failure(let error):
            print("\nfailed to create user. \(error)\n")
                    
            }
        }
    }
    
    public func signIn(
        with email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                if error != nil {
                    completion(.failure(error!))
                }
                else {
                    completion(.failure(AuthError.signingInUserError))
                }
                
                return
            }
            
            let user = result.user
            print("Created User: \(user)")
            completion(.success(user))
            return
        }
    }
    
    
    
    
    public func signOut() {
        do {
            try auth.signOut()
        }
        catch {
            print("\nerror signing out\n")
        }
        
    }
}
