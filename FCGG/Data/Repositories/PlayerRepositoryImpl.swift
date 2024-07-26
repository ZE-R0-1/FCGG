//
//  PlayerRepositoryImpl.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

// PlayerRepository 프로토콜을 구현하는 클래스 정의
class PlayerRepositoryImpl: PlayerRepository {
    // 네트워크 요청을 처리하는 NetworkManager 인스턴스
    private let networkManager: NetworkManager
    
    // 초기화 메서드
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // 플레이어 닉네임을 가져오는 메서드
    func getPlayerNickName(name: String) -> Observable<String> {
        // NetworkManager의 getPlayerNickName 메서드를 호출하여 결과를 반환
        return networkManager.getPlayerNickName(name: name)
    }
    
    // 최대 디비전을 가져오는 메서드
    func getMaxDivision(ouid: String) -> Observable<[MaxDivision]> {
        // NetworkManager의 getMaxDivision 메서드를 호출하여 결과를 반환
        return networkManager.getMaxDivision(ouid: ouid)
    }
    
    // 사용자 기본 정보를 가져오는 메서드
    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo> {
        // NetworkManager의 getUserBasicInfo 메서드를 호출하여 결과를 반환
        return networkManager.getUserBasicInfo(ouid: ouid)
    }
    
    // 매치 타입들을 가져오는 메서드
    func getMatchTypes() -> Observable<[MatchType]> {
        // NetworkManager의 getMatchTypes 메서드를 호출하여 결과를 반환
        return networkManager.getMatchTypes()
    }
    
    // 디비전 메타 데이터를 가져오는 메서드
    func getDivisions() -> Observable<[DivisionMeta]> {
        // NetworkManager의 getDivisions 메서드를 호출하여 결과를 반환
        return networkManager.getDivisions()
    }
    
    // 사용자 매치들을 가져오는 메서드
    func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> Observable<[String]> {
        // NetworkManager의 getUserMatches 메서드를 호출하여 결과를 반환
        return networkManager.getUserMatches(ouid: ouid, matchtype: matchtype, offset: offset, limit: limit)
    }
}
