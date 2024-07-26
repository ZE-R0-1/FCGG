//
//  PlayerRepositoryImpl.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

class PlayerRepositoryImpl: PlayerRepository {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getPlayerID(name: String) -> Observable<String> {
        return networkManager.getPlayerID(name: name)
    }
    
    func getMaxDivision(ouid: String) -> Observable<[MaxDivision]> {
        return networkManager.getMaxDivision(ouid: ouid)
    }
    
    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo> {
        return networkManager.getUserBasicInfo(ouid: ouid)
    }
    
    func getMatchTypes() -> Observable<[MatchType]> {
        return networkManager.getMatchTypes()
    }
    
    func getDivisions() -> Observable<[DivisionMeta]> {
        return networkManager.getDivisions()
    }
    
    func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> Observable<[String]> {
        return networkManager.getUserMatches(ouid: ouid, matchtype: matchtype, offset: offset, limit: limit)
    }
}
