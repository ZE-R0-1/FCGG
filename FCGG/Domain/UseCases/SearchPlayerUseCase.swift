//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol SearchPlayerUseCase {
    func execute(name: String) -> Observable<(UserBasicInfo, [Division])>
}

class SearchPlayerUseCaseImpl: SearchPlayerUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }

    func execute(name: String) -> Observable<(UserBasicInfo, [Division])> {
        return playerRepository.getPlayerID(name: name)
            .flatMap { [weak self] ouid -> Observable<(UserBasicInfo, [Division])> in
                guard let self = self else { return Observable.empty() }
                let basicInfo = self.playerRepository.getUserBasicInfo(ouid: ouid)
                let maxDivision = self.playerRepository.getMaxDivision(ouid: ouid)
                return Observable.zip(basicInfo, maxDivision)
            }
    }
}
