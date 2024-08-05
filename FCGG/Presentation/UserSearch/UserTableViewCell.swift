//
//  UserTableViewCell.swift
//  FCGG
//
//  Created by USER on 8/5/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let ouidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(nicknameLabel)
        containerView.addSubview(levelLabel)
        containerView.addSubview(ouidLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        ouidLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nicknameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nicknameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            levelLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            levelLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            ouidLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 8),
            ouidLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            ouidLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            ouidLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with user: User) {
        nicknameLabel.text = user.nickname
        levelLabel.text = "레벨: \(user.level)"
        ouidLabel.text = "OUID: \(user.ouid)"
    }
}
