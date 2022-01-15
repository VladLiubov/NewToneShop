//
//  StorageManager.swift
//  teamTest
//
//  Created by Admin on 16.12.2021.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init () {}
    
    public func uploadBlogHeaderImage(
        email: String,
        image: UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image.png() else {
            return
        }

        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadUrlForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        container
            .reference(withPath: "post_headers/\(emailComponent)/\(postId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func uploadAvatar (
        image: UIImage,
        completion: @escaping (URL) -> Void
    ) {
        guard let pngData = image.png() else {
            return
        }
        let ref =  container
            .reference(withPath: "avatars/\(UUID().uuidString).png")
       
            ref.putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    return
                }
                ref.downloadURL { url, _ in
                    guard let downloadURL = url else {
                         return
                       }
                    completion(downloadURL)
                }
            }
    }
    
}

extension UIImage {
    func png(isOpaque: Bool = true) -> Data? { flattened(isOpaque: isOpaque).pngData() }
    func flattened(isOpaque: Bool = true) -> UIImage {
        if imageOrientation == .up { return self }
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in draw(at: .zero) }
    }
}
