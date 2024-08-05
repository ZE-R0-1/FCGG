//
//  SearchPlayerUseCase.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift

protocol UserSearchUseCase {
    func searchUser(name: String) -> Observable<User>
}

class UserSearchUseCaseImpl: UserSearchUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func searchUser(name: String) -> Observable<User> {
        return repository.searchUser(name: name)
    }
}
