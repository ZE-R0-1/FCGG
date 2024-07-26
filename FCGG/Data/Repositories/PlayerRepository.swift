//
//  PlayerRepository.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol PlayerRepository {
    func getPlayerID(name: String) -> Observable<String>
    func getMaxDivision(ouid: String) -> Observable<[MaxDivision]>
    func getUserBasicInfo(ouid: String) -> Observable<UserBasicInfo>
    func getMatchTypes() -> Observable<[MatchType]>
    func getDivisions() -> Observable<[DivisionMeta]>
    func getUserMatches(ouid: String, matchtype: Int, offset: Int, limit: Int) -> Observable<[String]>
}
