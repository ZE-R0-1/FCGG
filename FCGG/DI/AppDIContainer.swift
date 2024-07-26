//
//  AppDIContainer.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

// 앱의 의존성 주입 컨테이너 클래스 정의
class AppDIContainer {
    // 네트워크 매니저를 lazy로 초기화
    lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()

    // 플레이어 리포지토리를 lazy로 초기화
    lazy var playerRepository: PlayerRepository = {
        return PlayerRepositoryImpl(networkManager: networkManager)
    }()

    // 검색 플레이어 유스케이스를 lazy로 초기화
    lazy var searchPlayerUseCase: SearchPlayerUseCase = {
        return SearchPlayerUseCaseImpl(playerRepository: playerRepository)
    }()
    
    // 홈 뷰 컨트롤러를 생성하는 메서드
    func makeHomeViewController() -> HomeViewController {
        // HomeViewModel을 생성하여 HomeViewController에 주입
        let viewModel = HomeViewModel(searchPlayerUseCase: searchPlayerUseCase)
        return HomeViewController(viewModel: viewModel)
    }
    
    // 메인 탭 바 컨트롤러를 생성하는 메서드
    func makeMainTabBarController() -> UITabBarController {
        // MainTabBarController를 생성하고, DI 컨테이너를 주입
        return MainTabBarController(appDIContainer: self)
    }
}
