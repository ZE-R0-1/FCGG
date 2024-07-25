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
    
    private let matchButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let matchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchCell")
        return tableView
    }()
    
    private var matchButtons: [UIButton] = []
    private var currentMatchType: String?
    private var matches: [(String, [String])] = []
    
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
        
        [nicknameLabel, levelLabel, rankInfoLabel, matchButtonsStackView, matchHistoryTableView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            
            matchButtonsStackView.topAnchor.constraint(equalTo: rankInfoLabel.bottomAnchor, constant: 16),
            matchButtonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            matchButtonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            matchHistoryTableView.topAnchor.constraint(equalTo: matchButtonsStackView.bottomAnchor, constant: 16),
            matchHistoryTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            matchHistoryTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            matchHistoryTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func configure(nickname: String, level: Int, rankInfo: String, matches: [(String, [String])]) {
        nicknameLabel.text = nickname
        levelLabel.text = "레벨: \(level)"
        rankInfoLabel.text = rankInfo
        self.matches = matches
        
        
        matchHistoryTableView.dataSource = self
        setupMatchButtons()
    }
    
    private func setupMatchButtons() {
        matchButtons.forEach { $0.removeFromSuperview() }
        matchButtons.removeAll()
        matchButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, (matchType, _)) in matches.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(matchType, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(matchButtonTapped(_:)), for: .touchUpInside)
            matchButtons.append(button)
            matchButtonsStackView.addArrangedSubview(button)
        }
        
        if let firstMatchType = matches.first?.0 {
            print("Setting up initial match type: \(firstMatchType)")
            showMatches(for: firstMatchType)
        } else {
            print("No match types available")
        }
    }
    
    @objc private func matchButtonTapped(_ sender: UIButton) {
        let matchType = matches[sender.tag].0
        showMatches(for: matchType)
    }
    
    private func showMatches(for matchType: String) {
        currentMatchType = matchType
        matchButtons.forEach { $0.isSelected = $0.title(for: .normal) == matchType }
        DispatchQueue.main.async {
            self.matchHistoryTableView.reloadData()
        }
    }
}

extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentMatchType = currentMatchType,
              let matchIds = matches.first(where: { $0.0 == currentMatchType })?.1 else {
            print("No matches found for type: \(currentMatchType ?? "nil")")
            return 0
        }
        print("Number of matches for \(currentMatchType): \(matchIds.count)")
        return matchIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        guard let currentMatchType = currentMatchType,
              let matchIds = matches.first(where: { $0.0 == currentMatchType })?.1 else {
            print("Failed to get match IDs for type: \(currentMatchType ?? "nil")")
            return cell
        }
        let matchId = matchIds[indexPath.row]
        cell.textLabel?.text = matchId
        print("Configuring cell for match ID: \(matchId)")
        return cell
    }
}
