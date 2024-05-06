//
//  Follower.swift
//  GHFollowersApp
//
//  Created by abdullah on 6.05.2024.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
