//
//  SearchResultView.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

class SearchResultView: UIView {
    private let containerView = UIView()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let rankInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let matchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(levelLabel)
        containerView.addSubview(rankInfoLabel)
        containerView.addSubview(matchHistoryTableView)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        rankInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        matchHistoryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            nicknameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            levelLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            rankInfoLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16),
            rankInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rankInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            matchHistoryTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            matchHistoryTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            matchHistoryTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func configure(nickname: String, level: Int, rankInfo: String, matches: [String]) {
        nicknameLabel.text = nickname
        levelLabel.text = "레벨: \(level)"
        rankInfoLabel.text = rankInfo
        
        matchHistoryTableView.dataSource = self
        matchHistoryTableView.reloadData()
    }
}

extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // 예시로 5개의 매치 기록을 보여줍니다.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        cell.textLabel?.text = "매치 \(indexPath.row + 1): 승리" // 예시 데이터
        return cell
    }
}
