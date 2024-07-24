//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol SearchPlayerUseCase {
    func execute(name: String) -> Observable<[Division]>
}

class SearchPlayerUseCaseImpl: SearchPlayerUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }

    func execute(name: String) -> Observable<[Division]> {
        return playerRepository.getPlayerID(name: name)
            .flatMap { [weak self] ouid -> Observable<[Division]> in
                guard let self = self else { return Observable.empty() }
                return self.playerRepository.getMaxDivision(ouid: ouid)
            }
    }
}
