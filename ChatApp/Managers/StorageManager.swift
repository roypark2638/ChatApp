//
//  StorageManager.swift
//  ChatApp
//
//  Created by Roy Park on 5/6/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    init() {}
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToDownloadURL
    }
    
    /*
     /images/roy@gmail.com_profile_picture.png
     */
    
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    
    /// Uploads picture to firebase storage and return url string to download
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - fileName: <#fileName description#>
    ///   - completion: <#completion description#>
    public func uploadProfilePicture(
        with data: Data,
        fileName: String,
        completion: @escaping UploadPictureCompletion
    ) {
        let path = "images/\(fileName)"
        print(path)
        storage.child(path).putData(data, metadata: nil) { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self?.storage.child(path).downloadURL { url, error in
                guard let url = url, error == nil else {
                    if let error = error {
                        print("Failed to download URL with an error: \(error)")
                        completion(.failure(error))
                        return
                    }
                    print("Failed to download URL")
                    completion(.failure(StorageError.failedToDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
        

    }

}
