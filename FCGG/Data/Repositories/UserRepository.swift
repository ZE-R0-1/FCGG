//
//  PlayerRepository.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol UserRepository {
    func getInfo(nickname: String) -> Observable<User>
    func getMaxDivisions(nickname: String) -> Observable<[MaxDivision]>
    func getMatchHistory(nickname: String) -> Observable<[Match]>
}

class UserRepositoryImpl: UserRepository {
    private let firebaseFunctions: FirebaseFunctionsService

    init(firebaseFunctions: FirebaseFunctionsService) {
        self.firebaseFunctions = firebaseFunctions
    }

    func getInfo(nickname: String) -> Observable<User> {
        return firebaseFunctions.getPlayerBasicInfo(nickname: nickname)
    }
    
    func getMaxDivisions(nickname: String) -> Observable<[MaxDivision]> {
        return firebaseFunctions.getPlayerMaxDivision(nickname: nickname)
    }
    
    func getMatchHistory(nickname: String) -> Observable<[Match]> {
        return firebaseFunctions.getPlayerMatchHistory(nickname: nickname)
    }
}
