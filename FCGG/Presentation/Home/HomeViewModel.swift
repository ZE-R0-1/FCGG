//
//  ViewController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift
import RxCocoa

class HomeViewModel {
    private let searchPlayerUseCase: SearchPlayerUseCase
    private let disposeBag = DisposeBag()
    
    // Input
    let searchQuery = PublishSubject<String>()
    
    // Output
    let searchResult = PublishSubject<(UserBasicInfo, [(MatchType, MaxDivision, DivisionMeta)], [String: [String]])>()
    let error = PublishSubject<Error>()
    
    init(searchPlayerUseCase: SearchPlayerUseCase) {
        self.searchPlayerUseCase = searchPlayerUseCase
        bindInputs()
    }

    private func bindInputs() {
        searchQuery
            .flatMapLatest { [unowned self] query in
                self.searchPlayerUseCase.execute(name: query)
                    .catch { error in
                        self.error.onNext(error)
                        return Observable.empty()
                    }
            }
            .map { userInfo, divisions, matchTypes, divisionMetas, matches in
                let rankInfos = divisions.compactMap { division -> (MatchType, MaxDivision, DivisionMeta)? in
                    guard let matchType = matchTypes.first(where: { $0.matchtype == division.matchType }),
                          let divisionMeta = divisionMetas.first(where: { $0.divisionId == division.division }) else {
                        return nil
                    }
                    return (matchType, division, divisionMeta)
                }
                let formattedMatches = Dictionary(uniqueKeysWithValues: matches.map { (key, value) in
                    let matchTypeDesc = matchTypes.first(where: { $0.matchtype == key })?.desc ?? "Unknown"
                    return (matchTypeDesc, value)
                })
                return (userInfo, rankInfos, formattedMatches)
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
    }
}
