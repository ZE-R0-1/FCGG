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
    lazy var user: Driver<User> = {
        return self.searchText
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] query in
                self.useCase.searchUser(name: query)
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
            .asDriver(onErrorJustReturn: User(ouid: "", nickname: "", level: 0, maxDivisions: []))
    }()
    
    private let disposeBag = DisposeBag()

    init(useCase: UserSearchUseCase) {
        self.useCase = useCase
    }
}
