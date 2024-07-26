//
//  AppDIContainer.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

class AppDIContainer {
    lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()

    lazy var playerRepository: PlayerRepository = {
        return PlayerRepositoryImpl(networkManager: networkManager)
    }()

    lazy var searchPlayerUseCase: SearchPlayerUseCase = {
        return SearchPlayerUseCaseImpl(playerRepository: playerRepository)
    }()
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(searchPlayerUseCase: searchPlayerUseCase)
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeMainTabBarController() -> UITabBarController {
        return MainTabBarController(appDIContainer: self)
    }
}
