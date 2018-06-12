//
//  UserStats.swift
//  BuscadorUsuarios
//
//  Created by Néstor Iván on 11/06/18.
//  Copyright © 2018 Néstor Iván. All rights reserved.
//

import Foundation

struct UserStats: Codable {
    
    let name: String?
    let location: String?
    let followers: Int?
    let avatarUrl: URL?
    let repos: Int?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case location
        case followers
        case repos = "public_repos"
        case avatarUrl = "avatar_url"
        
    }
}


