//
//  PlayerRepository.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol UserRepository {
    func searchUser(name: String) -> Observable<User>
}

class UserRepositoryImpl: UserRepository {
    private let firebaseFunctions: FirebaseFunctionsService

    init(firebaseFunctions: FirebaseFunctionsService) {
        self.firebaseFunctions = firebaseFunctions
    }

    func searchUser(name: String) -> Observable<User> {
        return firebaseFunctions.getPlayerData(name: name)
    }
}
