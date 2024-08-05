//
//  AppDIContainer.swift
//  FCGG
//
//  Created by USER on 8/2/24.
//

import UIKit

class AppDIContainer {
    
    // 의존성들을 여기에 선언
    lazy var firebaseFunctions: FirebaseFunctionsService = {
        return FirebaseFunctionsServiceImpl()
    }()
    
    lazy var userRepository: UserRepository = {
        return UserRepositoryImpl(firebaseFunctions: firebaseFunctions)
    }()
    
    func makeUserSearchViewController() -> UIViewController {
        let useCase = UserSearchUseCaseImpl(repository: userRepository)
        let viewModel = UserSearchViewModel(useCase: useCase)
        return UserSearchViewController(viewModel: viewModel)
    }
}
