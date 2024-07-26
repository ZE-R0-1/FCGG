//
//  SearchResultView.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit

// SearchResultView는 선수 검색 결과를 표시하는 커스텀 뷰
class SearchResultView: UIView {
    // 컨테이너 뷰는 모든 UI 요소를 포함하는 상위 뷰
    private let containerView = UIView()
    
    // 선수의 닉네임을 표시하는 레이블
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24) // 볼드체로 설정
        return label
    }()
    
    // 선수의 레벨을 표시하는 레이블
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18) // 기본 시스템 폰트로 설정
        return label
    }()
    
    // 선수의 랭크 정보를 표시하는 레이블
    private let rankInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16) // 기본 시스템 폰트로 설정
        label.numberOfLines = 0 // 여러 줄로 표시 가능
        return label
    }()
    
    // 매치 타입 버튼들을 담을 스택 뷰
    private let matchButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal // 수평 방향으로 배치
        stackView.distribution = .fillEqually // 버튼들이 균등하게 배치되도록 설정
        stackView.spacing = 10 // 버튼 간의 간격 설정
        return stackView
    }()
    
    // 매치 히스토리를 표시할 테이블 뷰
    private let matchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MatchCell") // 셀 등록
        return tableView
    }()
    
    // 매치 버튼들을 담을 배열
    private var matchButtons: [UIButton] = []
    // 현재 선택된 매치 타입
    private var currentMatchType: String?
    // 매치 데이터를 담을 배열 (매치 타입과 매치 ID 리스트)
    private var matches: [(String, [String])] = []
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // NSCoder를 통한 초기화가 구현되지 않았음을 표시
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰와 서브뷰들을 설정하는 메서드
    private func setupViews() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 서브뷰들을 컨테이너 뷰에 추가하고 오토 레이아웃 설정
        [nicknameLabel, levelLabel, rankInfoLabel, matchButtonsStackView, matchHistoryTableView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 뷰의 레이아웃 설정
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 닉네임 레이블의 레이아웃 설정
            nicknameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 레벨 레이블의 레이아웃 설정
            levelLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // 랭크 정보 레이블의 레이아웃 설정
            rankInfoLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16),
            rankInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rankInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 매치 버튼 스택 뷰의 레이아웃 설정
            matchButtonsStackView.topAnchor.constraint(equalTo: rankInfoLabel.bottomAnchor, constant: 16),
            matchButtonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            matchButtonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 매치 히스토리 테이블 뷰의 레이아웃 설정
            matchHistoryTableView.topAnchor.constraint(equalTo: matchButtonsStackView.bottomAnchor, constant: 16),
            matchHistoryTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            matchHistoryTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            matchHistoryTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // 뷰를 설정하는 메서드
    func configure(nickname: String, level: Int, rankInfo: String, matches: [(String, [String])]) {
        nicknameLabel.text = nickname
        levelLabel.text = "레벨: \(level)"
        rankInfoLabel.text = rankInfo
        self.matches = matches
        
        // 테이블 뷰의 데이터 소스를 설정하고 매치 버튼들을 설정
        matchHistoryTableView.dataSource = self
        setupMatchButtons()
    }
    
    // 매치 버튼들을 설정하는 메서드
    private func setupMatchButtons() {
        matchButtons.forEach { $0.removeFromSuperview() }
        matchButtons.removeAll()
        matchButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 각 매치 타입에 대한 버튼을 생성하고 스택 뷰에 추가
        for (index, (matchType, _)) in matches.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(matchType, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(matchButtonTapped(_:)), for: .touchUpInside)
            matchButtons.append(button)
            matchButtonsStackView.addArrangedSubview(button)
        }
        
        // 첫 번째 매치 타입이 있으면 해당 타입을 표시
        if let firstMatchType = matches.first?.0 {
            print("Setting up initial match type: \(firstMatchType)")
            showMatches(for: firstMatchType)
        } else {
            print("No match types available")
        }
    }
    
    // 매치 버튼이 탭되었을 때 호출되는 메서드
    @objc private func matchButtonTapped(_ sender: UIButton) {
        let matchType = matches[sender.tag].0
        showMatches(for: matchType)
    }
    
    // 선택된 매치 타입에 맞는 매치들을 표시하는 메서드
    private func showMatches(for matchType: String) {
        currentMatchType = matchType
        matchButtons.forEach { $0.isSelected = $0.title(for: .normal) == matchType }
        DispatchQueue.main.async {
            self.matchHistoryTableView.reloadData()
        }
    }
}

// UITableViewDataSource 프로토콜을 채택하여 테이블 뷰의 데이터 소스 구현
extension SearchResultView: UITableViewDataSource {
    // 테이블 뷰의 행 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentMatchType = currentMatchType,
              let matchIds = matches.first(where: { $0.0 == currentMatchType })?.1 else {
            print("No matches found for type: \(currentMatchType ?? "nil")")
            return 0
        }
        print("Number of matches for \(currentMatchType): \(matchIds.count)")
        return matchIds.count
    }
    
    // 테이블 뷰의 셀을 구성하는 메서드
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
