//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol UserSearchUseCase {
    func getInfo(name: String) -> Observable<User>
    func getMaxDivision(name: String) -> Observable<[MaxDivision]>
    func getMatchHistory(name: String) -> Observable<[Match]>
}

class UserSearchUseCaseImpl: UserSearchUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getInfo(name: String) -> Observable<User> {
        return repository.getInfo(nickname: name)
    }
    
    func getMaxDivision(name: String) -> Observable<[MaxDivision]> {
        return repository.getMaxDivisions(nickname: name)
    }
    
    func getMatchHistory(name: String) -> Observable<[Match]> {
        return repository.getMatchHistory(nickname: name)
    }
}
