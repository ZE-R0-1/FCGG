//
//  MainTabBarController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

// UITabBarController를 상속받아 메인 탭 바 컨트롤러를 정의하는 클래스
class MainTabBarController: UITabBarController {
    // 의존성 주입 컨테이너를 저장하는 변수
    private let appDIContainer: AppDIContainer

    // 초기화 메서드
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(nibName: nil, bundle: nil)
    }

    // NSCoder를 통한 초기화가 구현되지 않았음을 표시
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 뷰가 로드될 때 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        // 탭 바에 표시할 뷰 컨트롤러들을 설정
        setupViewControllers()
    }

    // 탭 바에 표시할 뷰 컨트롤러들을 설정하는 메서드
    private func setupViewControllers() {
        // 홈 뷰 컨트롤러를 UINavigationController에 감싸서 추가
        let homeVC = UINavigationController(rootViewController: appDIContainer.makeHomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)

        // 선수 검색 뷰 컨트롤러를 UINavigationController에 감싸서 추가
        let playerSearchVC = UINavigationController(rootViewController: PlayerSearchViewController())
        playerSearchVC.tabBarItem = UITabBarItem(title: "선수 검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        // 랭킹 뷰 컨트롤러를 UINavigationController에 감싸서 추가
        let rankingVC = UINavigationController(rootViewController: RankingViewController())
        rankingVC.tabBarItem = UITabBarItem(title: "랭킹", image: UIImage(systemName: "star"), tag: 2)

        // 통계 뷰 컨트롤러를 UINavigationController에 감싸서 추가
        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController())
        statisticsVC.tabBarItem = UITabBarItem(title: "통계", image: UIImage(systemName: "chart.bar"), tag: 3)

        // 커뮤니티 뷰 컨트롤러를 UINavigationController에 감싸서 추가
        let communityVC = UINavigationController(rootViewController: CommunityViewController())
        communityVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "person.3"), tag: 4)

        // 탭 바에 뷰 컨트롤러들을 설정
        viewControllers = [homeVC, playerSearchVC, rankingVC, statisticsVC, communityVC]
    }
}
