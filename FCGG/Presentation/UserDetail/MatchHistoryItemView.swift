//
//  MatchHistoryItemView.swift
//  FCGG
//
//  Created by USER on 8/19/24.
//

import UIKit

class MatchInfoView: UITableViewCell {
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let homeTeamView = TeamScoreView()
    private let awayTeamView = TeamScoreView()
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(homeTeamView)
        containerView.addSubview(awayTeamView)
        containerView.addSubview(vsLabel)
        containerView.addSubview(statsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [containerView, dateLabel, homeTeamView, awayTeamView, vsLabel, statsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            homeTeamView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            homeTeamView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            homeTeamView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            
            awayTeamView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            awayTeamView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            awayTeamView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            
            vsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            vsLabel.centerYAnchor.constraint(equalTo: homeTeamView.centerYAnchor),
            
            statsLabel.topAnchor.constraint(equalTo: homeTeamView.bottomAnchor, constant: 12),
            statsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with match: Match) {
        // Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: match.matchDate) {
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = match.matchDate
        }
        
        // Team info and score
        if let homeTeam = match.matchInfo.first, let awayTeam = match.matchInfo.last {
            homeTeamView.configure(with: homeTeam)
            awayTeamView.configure(with: awayTeam)
            
            // Key stats summary
            let homeStats = "\(homeTeam.matchDetail.possession)% 점유율 | \(homeTeam.shoot.shootTotal)(\(homeTeam.shoot.effectiveShootTotal)) 슛"
            let awayStats = "\(awayTeam.matchDetail.possession)% 점유율 | \(awayTeam.shoot.shootTotal)(\(awayTeam.shoot.effectiveShootTotal)) 슛"
            statsLabel.text = "\(homeStats)\n\(awayStats)"
        }
    }
}

// MARK: - TeamScoreView

class TeamScoreView: UIView {
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(teamNameLabel)
        addSubview(scoreLabel)
        
        [teamNameLabel, scoreLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            teamNameLabel.topAnchor.constraint(equalTo: topAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            teamNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: teamNameLabel.bottomAnchor, constant: 4),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with team: MatchInfo) {
        teamNameLabel.text = team.nickname
        scoreLabel.text = "\(team.shoot.goalTotal)"
        
        // 승패에 따른 색상 변경
        if team.matchDetail.matchResult == "승" {
            scoreLabel.textColor = .systemGreen
        } else if team.matchDetail.matchResult == "패" {
            scoreLabel.textColor = .systemRed
        } else {
            scoreLabel.textColor = .label
        }
    }
}
