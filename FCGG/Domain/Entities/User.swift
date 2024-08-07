//
//  MatchDetail.swift
//  FCGG
//
//  Created by USER on 7/31/24.
//

import Foundation

struct User: Codable {
    let ouid: String
    let nickname: String
    let level: Int
    let maxDivisions: [MaxDivision]
}

struct MaxDivision: Codable {
    let matchType: Int
    let matchTypeDesc: String
    let division: Int
    let divisionName: String
    let achievementDate: String
    let imageUrl: String
}
