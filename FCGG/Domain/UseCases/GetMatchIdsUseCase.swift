//
//  GetMatchIdsUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol GetMatchIDsUseCase {
    func execute(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]>
}

class GetMatchIDsUseCaseImpl: GetMatchIDsUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }

    func execute(matchType: Int, offset: Int, limit: Int, orderBy: String) -> Observable<[String]> {
        return playerRepository.getMatchIDs(matchType: matchType, offset: offset, limit: limit, orderBy: orderBy)
    }
}
