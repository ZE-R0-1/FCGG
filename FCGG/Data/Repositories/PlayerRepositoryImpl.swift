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
    
    func getMaxDivision(ouid: String) -> Observable<[Division]> {
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
    
    func getMatchIDs(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]> {
        return networkManager.getMatchIDs(matchType: matchType, offset: offset, limit: limit, orderBy: orderBy)
    }
}
