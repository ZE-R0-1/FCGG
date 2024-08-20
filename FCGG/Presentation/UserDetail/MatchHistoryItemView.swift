//
//  MatchHistoryItemView.swift
//  FCGG
//
//  Created by USER on 8/19/24.
//

import UIKit

import UIKit

class MatchInfoView: UIView {
    private let dateLabel = UILabel()
    private let scoreLabel = UILabel()
    private let statsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, scoreLabel, statsLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        [dateLabel, scoreLabel, statsLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
        }
    }
    
    func configure(with match: Match) {
        // Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: match.matchDate) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = match.matchDate
        }
        
        // Score and result
        if let homeTeam = match.matchInfo.first, let awayTeam = match.matchInfo.last {
            scoreLabel.text = "\(homeTeam.nickname) \(homeTeam.shoot.goalTotal) - \(awayTeam.shoot.goalTotal) \(awayTeam.nickname)"
            
            // Key stats summary
            let homeStats = "\(homeTeam.matchDetail.possession)% \(homeTeam.shoot.shootTotal)(\(homeTeam.shoot.effectiveShootTotal))"
            let awayStats = "\(awayTeam.matchDetail.possession)% \(awayTeam.shoot.shootTotal)(\(awayTeam.shoot.effectiveShootTotal))"
            statsLabel.text = "\(homeStats) - \(awayStats)"
        }
    }
}
