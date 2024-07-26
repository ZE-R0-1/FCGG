//
//  PlayerRepository.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

// PlayerRepository 프로토콜 정의
protocol PlayerRepository {
    // 플레이어 닉네임을 가져오는 메서드
    func getPlayerNickName(name: String) -> Observable<String>
    
    // 최대 등급을 가져오는 메서드
    func getMaxDivision(ouid: String) -> Observable<[MaxDivision]>
    
    // 사용자 기본 정보를 가져오는 메서드
    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo>
    
    // 매치 타입들을 가져오는 메서드
    func getMatchTypes() -> Observable<[MatchType]>
    
    // 등급식별자 메타 데이터를 가져오는 메서드
    func getDivisions() -> Observable<[DivisionMeta]>
    
    // 사용자 매치들을 가져오는 메서드
    func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> Observable<[String]>
}
