//
//  MatchSummaryCell.swift
//  FCGG
//
//  Created by USER on 8/19/24.
//

import UIKit

class MatchSummaryCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier = "MatchSummaryCell"

    private let resultLayer = CALayer()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private let opponentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    private let competitionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    private var userNickname: String?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1.0)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.layer.addSublayer(resultLayer)
        contentView.addSubview(resultLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(opponentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(competitionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        [resultLabel, scoreLabel, opponentLabel, dateLabel, competitionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            resultLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 60),

            scoreLabel.leadingAnchor.constraint(equalTo: resultLabel.trailingAnchor, constant: 16),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            opponentLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 16),
            opponentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            opponentLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -16),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            competitionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            competitionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update resultLayer frame
        resultLayer.frame = CGRect(x: 0, y: 0, width: 60, height: contentView.bounds.height)
        
        // Add some padding to the cell content
        let padding: CGFloat = 5
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    // MARK: - Configuration

    func configure(with match: Match, userNickname: String) {
        self.userNickname = userNickname

        guard let homeTeam = match.matchInfo.first, let awayTeam = match.matchInfo.last else { return }

        let userTeam: MatchInfo
        let opposingTeam: MatchInfo

        if homeTeam.nickname == userNickname {
            userTeam = homeTeam
            opposingTeam = awayTeam
        } else {
            userTeam = awayTeam
            opposingTeam = homeTeam
        }

        configureResult(with: userTeam.matchDetail.matchResult)
        scoreLabel.text = "\(awayTeam.shoot.goalTotal) : \(homeTeam.shoot.goalTotal)"
        opponentLabel.text = opposingTeam.nickname
        dateLabel.text = getRelativeTimeString(from: match.matchDate)
        competitionLabel.text = getCompetitionName(for: match.matchType)
    }

    private func configureResult(with result: String) {
        resultLabel.text = result
        switch result {
        case "승":
            resultLayer.backgroundColor = UIColor.systemBlue.cgColor
        case "패":
            resultLayer.backgroundColor = UIColor.systemRed.cgColor
        default:
            resultLayer.backgroundColor = UIColor.systemGray.cgColor
        }
    }
    
    private func getRelativeTimeString(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }

    private func getCompetitionName(for matchType: Int) -> String {
        switch matchType {
        case 30: return "리그 친선"
        case 40: return "클래식 1on1"
        case 50: return "공식경기"
        case 52: return "감독모드"
        case 60: return "공식 친선"
        case 204: return "볼타 친선"
        case 214: return "볼타 공식"
        case 224: return "볼타 AI대전"
        case 234: return "볼타 커스텀"
        default: return "기타"
        }
    }
}
