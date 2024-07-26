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
    
    private let bestRankLabel: UILabel = {
        let label = UILabel()
        label.text = "역대 최고 등급"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let rankInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RankInfoCell.self, forCellWithReuseIdentifier: "RankInfoCell")
        return collectionView
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
    private var rankInfos: [(MatchType, MaxDivision, DivisionMeta)] = []
    private var matches: [String: [String]] = [:]
    private var sortedRankInfos: [(MatchType, MaxDivision, DivisionMeta)] = []
    
    
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
        
        [nicknameLabel, levelLabel, bestRankLabel, rankInfoCollectionView, matchButtonsStackView, matchHistoryTableView].forEach {
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
            
            bestRankLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16),
            bestRankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            rankInfoCollectionView.topAnchor.constraint(equalTo: bestRankLabel.bottomAnchor, constant: 8),
            rankInfoCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rankInfoCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rankInfoCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            matchButtonsStackView.topAnchor.constraint(equalTo: rankInfoCollectionView.bottomAnchor, constant: 16),
            matchButtonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            matchButtonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            matchHistoryTableView.topAnchor.constraint(equalTo: matchButtonsStackView.bottomAnchor, constant: 16),
            matchHistoryTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            matchHistoryTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            matchHistoryTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        rankInfoCollectionView.dataSource = self
        rankInfoCollectionView.delegate = self
        matchHistoryTableView.dataSource = self
    }
    
    func configure(nickname: String, level: Int, rankInfos: [(MatchType, MaxDivision, DivisionMeta)], matches: [String: [String]]) {
        nicknameLabel.text = nickname
        levelLabel.text = "레벨: \(level)"
        
        // rankInfos를 divisionId 기준으로 정렬
        self.sortedRankInfos = rankInfos.sorted {
            $0.2.divisionId < $1.2.divisionId
        }
        
        self.matches = matches
        
        rankInfoCollectionView.reloadData()
        rankInfoCollectionView.collectionViewLayout.invalidateLayout()
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
        
        if let firstMatchType = matches.keys.first {
            showMatches(for: firstMatchType)
        }
    }
    
    @objc private func matchButtonTapped(_ sender: UIButton) {
        let matchType = Array(matches.keys)[sender.tag]
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

extension SearchResultView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedRankInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankInfoCell", for: indexPath) as! RankInfoCell
        let (matchType, maxDivision, divisionMeta) = sortedRankInfos[indexPath.item]
        cell.configure(matchType: matchType, maxDivision: maxDivision, divisionMeta: divisionMeta)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankInfoCell", for: indexPath) as! RankInfoCell
        let (matchType, maxDivision, divisionMeta) = sortedRankInfos[indexPath.item]
        cell.configure(matchType: matchType, maxDivision: maxDivision, divisionMeta: divisionMeta)
        let width = cell.calculateCellWidth()
        return CGSize(width: width, height: collectionView.bounds.height - 20)
    }
}

extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentMatchType = currentMatchType,
              let matchIds = matches[currentMatchType] else {
            return 0
        }
        return matchIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        guard let currentMatchType = currentMatchType,
              let matchIds = matches[currentMatchType] else {
            return cell
        }
        let matchId = matchIds[indexPath.row]
        cell.textLabel?.text = matchId
        return cell
    }
}
