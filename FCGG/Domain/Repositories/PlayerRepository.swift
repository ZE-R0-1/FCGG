//
//  PlayerRepository.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol PlayerRepository {
    func getPlayerID(name: String) -> Observable<String>
    func getMaxDivision(ouid: String) -> Observable<[Division]>
    func getMatchIDs(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]>
}
