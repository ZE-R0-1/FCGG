//
//  UserDetailViewModel.swift
//  FCGG
//
//  Created by USER on 8/6/24.
//

import RxSwift
import RxCocoa

class UserDetailViewModel {
    private let useCase: UserSearchUseCase
    let user: Driver<User>
    let maxDivisions: Driver<[MaxDivision]>
    
    init(useCase: UserSearchUseCase, nickname: String) {
        self.useCase = useCase
        
        let userObservable = useCase.searchUser(name: nickname)
            .share(replay: 1)
        
        user = userObservable
            .asDriver(onErrorJustReturn: User(ouid: "", nickname: "", level: 0, maxDivisions: []))
        
        maxDivisions = userObservable
            .map { $0.maxDivisions }
            .asDriver(onErrorJustReturn: [])
    }
}
