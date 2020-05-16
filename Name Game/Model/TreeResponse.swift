//
//  TreeResponse.swift
//  Name Game
//
//  Created by Michal Hus on 5/16/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

struct Tree: Codable {
    let firstName: String
    let lastName: String
    let headshot: Headshot
}

struct Headshot: Codable {
    let url: String?
}
