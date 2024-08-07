//
//  AppDIContainer.swift
//  FCGG
//
//  Created by USER on 8/2/24.
//

import UIKit

class AppDIContainer {
    
    // MARK: - Shared Dependencies
    
    lazy var firebaseFunctions: FirebaseFunctionsService = {
        return FirebaseFunctionsServiceImpl()
    }()
    
    lazy var userRepository: UserRepository = {
        return UserRepositoryImpl(firebaseFunctions: firebaseFunctions)
    }()
    
    // MARK: - View Controllers
    
    func makeUserSearchViewController() -> UIViewController {
        let useCase = UserSearchUseCaseImpl(repository: userRepository)
        let viewModel = UserSearchViewModel(useCase: useCase)
        return UserSearchViewController(viewModel: viewModel)
    }
}
