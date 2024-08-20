//
//  Match.swift
//  FCGG
//
//  Created by USER on 8/19/24.
//

import Foundation

struct Match: Codable {
    let matchId: String
    let matchDate: String
    let matchType: Int
    let matchInfo: [MatchInfo]
}

struct MatchInfo: Codable {
    let ouid: String
    let nickname: String
    let matchDetail: MatchDetail
    let shoot: Shoot
    let shootDetail: [ShootDetail]
    let pass: Pass
    let defence: Defence
    let player: [Player]
}

struct MatchDetail: Codable {
    let seasonId: Int
    let matchResult: String
    let matchEndType: Int
    let systemPause: Int
    let foul: Int
    let injury: Int
    let redCards: Int
    let yellowCards: Int
    let dribble: Int
    let cornerKick: Int
    let possession: Int
    let offsideCount: Int
    let averageRating: Double
    let controller: String
}

struct Shoot: Codable {
    let shootTotal: Int
    let effectiveShootTotal: Int
    let shootOutScore: Int
    let goalTotal: Int
    let goalTotalDisplay: Int
    let ownGoal: Int
    let shootHeading: Int
    let goalHeading: Int
    let shootFreekick: Int
    let goalFreekick: Int
    let shootInPenalty: Int
    let goalInPenalty: Int
    let shootOutPenalty: Int
    let goalOutPenalty: Int
    let shootPenaltyKick: Int
    let goalPenaltyKick: Int
}

struct ShootDetail: Codable {
    let goalTime: Int
    let x: Double
    let y: Double
    let type: Int
    let result: Int
    let spId: Int
    let spGrade: Int
    let spLevel: Int
    let spIdType: Bool
    let assist: Bool
    let assistSpId: Int
    let assistX: Double
    let assistY: Double
    let hitPost: Bool
    let inPenalty: Bool
}

struct Pass: Codable {
    let passTry: Int
    let passSuccess: Int
    let shortPassTry: Int
    let shortPassSuccess: Int
    let longPassTry: Int
    let longPassSuccess: Int
    let bouncingLobPassTry: Int
    let bouncingLobPassSuccess: Int
    let drivenGroundPassTry: Int
    let drivenGroundPassSuccess: Int
    let throughPassTry: Int
    let throughPassSuccess: Int
    let lobbedThroughPassTry: Int
    let lobbedThroughPassSuccess: Int
}

struct Defence: Codable {
    let blockTry: Int
    let blockSuccess: Int
    let tackleTry: Int
    let tackleSuccess: Int
}

struct Player: Codable {
    let spId: Int
    let spPosition: Int
    let spGrade: Int
    let status: PlayerStatus
}

struct PlayerStatus: Codable {
    let shoot: Int
    let effectiveShoot: Int
    let assist: Int
    let goal: Int
    let dribble: Int
    let intercept: Int
    let defending: Int
    let passTry: Int
    let passSuccess: Int
    let dribbleTry: Int
    let dribbleSuccess: Int
    let ballPossesionTry: Int
    let ballPossesionSuccess: Int
    let aerialTry: Int
    let aerialSuccess: Int
    let blockTry: Int
    let block: Int
    let tackleTry: Int
    let tackle: Int
    let yellowCards: Int
    let redCards: Int
    let spRating: Double
}
