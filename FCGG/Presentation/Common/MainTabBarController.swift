//
//  MainTabBarController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let homeVC = UINavigationController(rootViewController: appDIContainer.makeHomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)

        let playerSearchVC = UINavigationController(rootViewController: PlayerSearchViewController())
        playerSearchVC.tabBarItem = UITabBarItem(title: "선수 검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let rankingVC = UINavigationController(rootViewController: RankingViewController())
        rankingVC.tabBarItem = UITabBarItem(title: "랭킹", image: UIImage(systemName: "star"), tag: 2)

        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController())
        statisticsVC.tabBarItem = UITabBarItem(title: "통계", image: UIImage(systemName: "chart.bar"), tag: 3)

        let communityVC = UINavigationController(rootViewController: CommunityViewController())
        communityVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "person.3"), tag: 4)

        viewControllers = [homeVC, playerSearchVC, rankingVC, statisticsVC, communityVC]
    }
}
