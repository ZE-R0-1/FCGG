//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

// 플레이어 검색 유스케이스를 정의하는 프로토콜
protocol SearchPlayerUseCase {
    // 이름을 입력받아 여러 데이터를 비동기적으로 가져오는 메서드
    func execute(name: String) -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])>
}

// SearchPlayerUseCase 프로토콜을 구현하는 클래스
class SearchPlayerUseCaseImpl: SearchPlayerUseCase {
    // PlayerRepository를 의존성으로 갖는 변수
    private let playerRepository: PlayerRepository

    // 초기화 메서드
    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }
    
    // execute 메서드 구현
    func execute(name: String) -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])> {
        // 플레이어 닉네임을 통해 OUID를 가져옴
        return playerRepository.getPlayerNickName(name: name)
            .flatMap { [weak self] ouid -> Observable<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])> in
                // self가 해제되지 않았는지 확인
                guard let self = self else { return Observable.empty() }
                
                // OUID를 기반으로 사용자 기본 정보, 최대 디비전, 매치 타입, 디비전 메타 데이터를 가져오는 Observable
                let basicInfo = self.playerRepository.getUserBasicInfo(ouid: ouid)
                let maxDivision = self.playerRepository.getMaxDivision(ouid: ouid)
                let matchTypes = self.playerRepository.getMatchTypes()
                let divisions = self.playerRepository.getDivisions()
                
                // 매치 타입별로 사용자 매치를 가져오는 Observable
                let matchesObservable = matchTypes.flatMap { types -> Observable<[Int: [String]]> in
                    // 각 매치 타입에 대해 매치 정보를 가져오는 Observable 생성
                    let matchObservables = types.map { type in
                        self.playerRepository.getUserMatches(ouid: ouid, matchtype: type.matchtype, offset: 0, limit: 100)
                            .map { matches in (type.matchtype, matches) }
                    }
                    // 모든 매치 정보를 가져온 후, 비어 있지 않은 결과만을 필터링하여 딕셔너리로 변환
                    return Observable.zip(matchObservables)
                        .map { results in
                            Dictionary(uniqueKeysWithValues: results.filter { !$0.1.isEmpty })
                        }
                }
                
                // 모든 비동기 작업을 동시에 처리하고, 결과를 튜플로 반환
                return Observable.zip(basicInfo, maxDivision, matchTypes, divisions, matchesObservable)
            }
    }
}
