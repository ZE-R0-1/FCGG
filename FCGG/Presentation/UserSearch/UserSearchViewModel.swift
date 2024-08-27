//
//  UserSearchViewModel.swift
//  FCGG
//
//  Created by USER on 7/26/24.
//

import RxSwift
import RxCocoa
import Foundation

class UserSearchViewModel {
    private let useCase: UserSearchUseCase
    let searchText = PublishSubject<String>()
    
    private let matchHistoryRelay = BehaviorRelay<[Match]>(value: [])
    private let userRelay = BehaviorRelay<User?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    var isLoading: Driver<Bool> {
        return isLoadingRelay.asDriver()
    }
    
    lazy var user: Driver<User> = {
        return self.searchText
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] query in
                self.useCase.getInfo(name: query)
                    .catch { error in
                        print("UserSearchViewModel 오류: \(error)")
                        if let nsError = error as NSError? {
                            print("오류 도메인: \(nsError.domain)")
                            print("오류 코드: \(nsError.code)")
                            print("오류 상세 정보: \(nsError.userInfo)")
                        }
                        return Observable.empty()
                    }
            }
            .do(onNext: { [weak self] user in
                self?.userRelay.accept(user)
            })
            .asDriver(onErrorJustReturn: User(ouid: "", nickname: "", level: 0, maxDivisions: []))
    }()
    
    lazy var maxDivisions: Driver<[MaxDivision]> = {
        return self.searchText
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] query in
                self.useCase.getMaxDivision(name: query)
                    .catch { error in
                        print("MaxDivision 가져오기 오류: \(error)")
                        return Observable.just([])
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }()

    lazy var matchHistory: Driver<[Match]> = {
        return self.searchText
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [unowned self] query in
                self.useCase.getMatchHistory(name: query)
                    .catch { error in
                        print("MatchHistory 가져오기 오류: \(error)")
                        return Observable.just([])
                    }
            }
            .do(onNext: { [weak self] matches in
                self?.matchHistoryRelay.accept(matches)
                self?.isLoadingRelay.accept(false)
            })
            .asDriver(onErrorJustReturn: [])
    }()
    
    var currentUser: User? {
        return userRelay.value
    }
    
    var currentMatchHistory: [Match] {
        return matchHistoryRelay.value
    }
    
    private let disposeBag = DisposeBag()
    
    init(useCase: UserSearchUseCase) {
        self.useCase = useCase
    }
}
