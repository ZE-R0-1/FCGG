//
//  APIEndpoints.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

enum APIEndpoints {
    
    // 유저 닉네임을 가져오는 엔드포인트를 반환하는 함수
    static func getPlayerID(nickName: String) -> String {
        // 주어진 이름을 사용하여 플레이어 ID를 조회하는 URL 경로를 반환
        return "/id?nickname=\(nickName)"
    }

    // 최대 등급을 가져오는 엔드포인트를 반환하는 함수
    static func getMaxDivision(ouid: String) -> String {
        // 주어진 사용자 ID(ouid)를 사용하여 최대 디비전을 조회하는 URL 경로를 반환
        return "/user/maxdivision?ouid=\(ouid)"
    }

    // 사용자 기본 정보를 가져오는 엔드포인트를 반환하는 함수
    static func getUserBasicInfo(ouid: String) -> String {
        // 주어진 사용자 ID(ouid)를 사용하여 기본 정보를 조회하는 URL 경로를 반환
        return "/user/basic?ouid=\(ouid)"
    }
    
    // 사용자 매치들을 가져오는 엔드포인트를 반환하는 함수
    static func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> String {
        // 주어진 사용자 ID(ouid), 매치 타입, 오프셋, 제한 수를 사용하여 매치들을 조회하는 URL 경로를 반환
        return "/user/match?ouid=\(ouid)&matchtype=\(matchtype)&offset=\(offset)&limit=\(limit)"
    }
}
