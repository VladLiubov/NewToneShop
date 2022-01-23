//
//  Constans.swift
//  teamTest
//
//  Created by Admin on 28.11.2021.
//

import Foundation

struct Constants {
    
    struct Storyboard {
       static let tabBarViewController = "TabBar"
       static let sigInVC = "SigIn"
       static let createVC = "createPost"
    }
}

struct BlogPost: Identifiable, Equatable {
    var id: String { identifier }
    let identifier: String
    let title: String
    let cost: String
    let headerImageUrl: URL?
    let text: String
    let user: User?
    
    static func == (lhs: BlogPost, rhs: BlogPost) -> Bool {
        lhs.id == rhs.id
    }
}

struct User {
    let name: String
    let email: String
    let profilePictureRef: String?
}

