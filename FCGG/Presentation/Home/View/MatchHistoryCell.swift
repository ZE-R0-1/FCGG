//
//  MatchHistoryCell.swift
//  FCGG
//
//  Created by USER on 7/31/24.
//

import UIKit

class MatchHistoryCell: UITableViewCell {
    private let matchIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let matchTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(matchIdLabel)
        contentView.addSubview(matchTypeLabel)

        matchIdLabel.translatesAutoresizingMaskIntoConstraints = false
        matchTypeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            matchIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            matchIdLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            matchTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            matchTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            matchIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: matchTypeLabel.leadingAnchor, constant: -8)
        ])
    }

    func configure(matchId: String, matchType: String) {
        matchIdLabel.text = matchId
        matchTypeLabel.text = matchType
    }
}
