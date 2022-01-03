//
//  DatabaseManager.swift
//  teamTest
//
//  Created by Admin on 16.12.2021.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()

    private let database = Firestore.firestore()

    private init() {}

    public func insert(
        blogPost: BlogPost,
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
 
        let data: [String: Any] = [
            "id": blogPost.identifier,
            "title": blogPost.title,
            "body": blogPost.text,
            "cost": blogPost.cost,
            "headerImageUrl": blogPost.headerImageUrl?.absoluteString ?? ""
        ]

        database
            .collection("users")
            .document(UserDefaults.standard.string(forKey: "uid")!)
            .collection("posts")
            .document(blogPost.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }

    public func getAllPosts(
        completion: @escaping ([BlogPost]) -> Void
    ) {
        database
            .collectionGroup("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                let result: [BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let cost = dictionary["cost"] as? String,
                          let imageUrlString = dictionary["headerImageUrl"] as? String else {
                        print("Invalid post fetch conversion")
                        return nil
                    }

                    let post = BlogPost(
                        identifier: id,
                        title: title,
                        cost: cost,
                        headerImageUrl: URL(string: imageUrlString),
                        text: body
                    )
                    return post
                })
                print("Feed posts: \(result.count)")
                completion(result)
            }
    }

    public func getPosts(
        completion: @escaping ([BlogPost]) -> Void
){
        database
            .collection("users")
            .document(UserDefaults.standard.string(forKey: "uid")!)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }

                let posts: [BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let cost = dictionary["cost"] as? String,
                          let imageUrlString = dictionary["headerImageUrl"] as? String else {
                        print("Invalid post fetch conversion")
                        return nil
                    }

                    let post = BlogPost(
                        identifier: id,
                        title: title,
                        cost: cost,
                        headerImageUrl: URL(string: imageUrlString),
                        text: body
                    )
                    return post
                })

                completion(posts)
            }
    }

    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        let data = [
            "email": user.email,
            "name": user.name
        ]

        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }

    public func getUser(
        email: String,
        completion: @escaping (User?) -> Void
    ) {
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil else {
                    return
                }

                let ref = data["profile_photo"]
                let user = User(name: name, email: email, profilePictureRef: ref)
                completion(user)
            }
    }

    func updateProfilePhoto(
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        let photoReference = "profile_pictures/\(path)/photo.png"

        let dbRef = database
            .collection("users")
            .document(path)

        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profile_photo"] = photoReference

            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }

    }
}
