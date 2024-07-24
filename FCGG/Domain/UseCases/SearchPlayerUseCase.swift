//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol SearchPlayerUseCase {
    func execute(name: String) -> Observable<(UserBasicInfo, [Division], [MatchType], [DivisionMeta])>
}

class SearchPlayerUseCaseImpl: SearchPlayerUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }

    func execute(name: String) -> Observable<(UserBasicInfo, [Division], [MatchType], [DivisionMeta])> {
        return playerRepository.getPlayerID(name: name)
            .flatMap { [weak self] ouid -> Observable<(UserBasicInfo, [Division], [MatchType], [DivisionMeta])> in
                guard let self = self else { return Observable.empty() }
                let basicInfo = self.playerRepository.getUserBasicInfo(ouid: ouid)
                let maxDivision = self.playerRepository.getMaxDivision(ouid: ouid)
                let matchTypes = self.playerRepository.getMatchTypes()
                let divisions = self.playerRepository.getDivisions()
                return Observable.zip(basicInfo, maxDivision, matchTypes, divisions)
            }
    }
}
