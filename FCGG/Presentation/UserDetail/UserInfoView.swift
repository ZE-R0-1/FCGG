//
//  UserInfoView.swift
//  FCGG
//
//  Created by USER on 8/6/24.
//

import UIKit

class UserInfoView: UIView {
    private let nicknameLabel = UILabel()
    private let levelLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        addSubview(nicknameLabel)
        addSubview(levelLabel)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            levelLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            levelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            levelLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        nicknameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        levelLabel.font = .systemFont(ofSize: 18)
        levelLabel.textColor = .systemGray
    }
    
    func configure(with user: User) {
        nicknameLabel.text = user.nickname
        levelLabel.text = "레벨: \(user.level)"
    }
}
