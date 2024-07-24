//
//  APIEndpoints.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

enum APIEndpoints {
    static func getPlayerID(name: String) -> String {
        return "/id?nickname=\(name)"
    }

    static func getMaxDivision(ouid: String) -> String {
        return "/user/maxdivision?ouid=\(ouid)"
    }

    static func getMatchIDs(matchType: Int, offset: Int, limit: Int, orderBy: String) -> String {
        return "/match?matchtype=\(matchType)&offset=\(offset)&limit=\(limit)&orderby=\(orderBy)"
    }
}
