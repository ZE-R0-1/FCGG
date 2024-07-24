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
    private let getMatchIDsUseCase: GetMatchIDsUseCase
    private let disposeBag = DisposeBag()
    
    // Input
    let searchQuery = PublishSubject<String>()
    
    // Output
    let searchResult = PublishSubject<(UserBasicInfo, [Division], [MatchType], [DivisionMeta])>()
    let error = PublishSubject<Error>()
    
    init(searchPlayerUseCase: SearchPlayerUseCase, getMatchIDsUseCase: GetMatchIDsUseCase) {
        self.searchPlayerUseCase = searchPlayerUseCase
        self.getMatchIDsUseCase = getMatchIDsUseCase
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
            .bind(to: searchResult)
            .disposed(by: disposeBag)
    }
}
