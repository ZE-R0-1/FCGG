//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol SearchPlayerUseCase {
    func execute(name: String) -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])>
}

class SearchPlayerUseCaseImpl: SearchPlayerUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }
    
    func execute(name: String) -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])> {
        return playerRepository.getPlayerNickName(name: name)
            .flatMap { [weak self] ouid -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])> in
                guard let self = self else { return Observable.empty() }
                
                let basicInfo = self.playerRepository.getUserBasicInfo(ouid: ouid)
                let maxDivision = self.playerRepository.getMaxDivision(ouid: ouid)
                let matchTypes = self.playerRepository.getMatchTypes()
                let divisions = self.playerRepository.getDivisions()
                
                let matchesObservable = matchTypes.flatMap { types -> Observable<[Int: [String]]> in
                    let matchObservables = types.map { type in
                        self.playerRepository.getUserMatches(ouid: ouid, matchtype: type.matchtype, offset: 0, limit: 100)
                            .map { matches in (type.matchtype, matches) }
                    }
                    return Observable.zip(matchObservables)
                        .map { results in
                            Dictionary(uniqueKeysWithValues: results.filter { !$0.1.isEmpty })
                        }
                }
                
                return Observable.zip(basicInfo, maxDivision, matchTypes, divisions, matchesObservable)
            }
    }
}
