//
//  RankInfoCell.swift
//  FCGG
//
//  Created by USER on 7/26/24.
//

import UIKit
import Kingfisher

class RankInfoCell: UICollectionViewCell {
    private let rankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let matchTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let divisionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [rankImageView, matchTypeLabel, divisionLabel, dateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            rankImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rankImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rankImageView.widthAnchor.constraint(equalToConstant: 60),
            rankImageView.heightAnchor.constraint(equalToConstant: 60),
            
            matchTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            matchTypeLabel.leadingAnchor.constraint(equalTo: rankImageView.trailingAnchor, constant: 8),
            matchTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            divisionLabel.topAnchor.constraint(equalTo: matchTypeLabel.bottomAnchor, constant: 4),
            divisionLabel.leadingAnchor.constraint(equalTo: rankImageView.trailingAnchor, constant: 8),
            divisionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: divisionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: rankImageView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(matchType: MatchType, maxDivision: MaxDivision, divisionMeta: DivisionMeta) {
        matchTypeLabel.text = matchType.desc
        divisionLabel.text = divisionMeta.divisionName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: maxDivision.achievementDate) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = maxDivision.achievementDate
        }
        
        let imageNumber = (divisionMeta.divisionId - 800) / 100
        let imageURL = URL(string: "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank\(imageNumber)_m.png")
        rankImageView.kf.setImage(with: imageURL)
    }
    
    func calculateCellWidth() -> CGFloat {
        let dateWidth = dateLabel.intrinsicContentSize.width
        let matchTypeWidth = matchTypeLabel.intrinsicContentSize.width
        let divisionWidth = divisionLabel.intrinsicContentSize.width
        let maxTextWidth = max(dateWidth, max(matchTypeWidth, divisionWidth))
        
        // 이미지 너비 + 최대 텍스트 너비 + 좌우 여백
        return 60 + maxTextWidth + 24  // 60은 이미지 너비, 24는 좌우 여백 (8 + 8 + 8)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = CGSize(width: calculateCellWidth(), height: attributes.size.height)
        return attributes
    }
}
