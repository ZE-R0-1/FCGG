//
//  Division.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

struct MaxDivision: Codable {
    // 매치 종류를 나타내는 정수형 프로퍼티
    let matchType: Int
    
    // 등급 식별자를 나타내는 정수형 프로퍼티
    let division: Int
    
    // 최고 등급 달성 일자를 나타내는 문자열 프로퍼티
    let achievementDate: String
}
