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
        
        let imageNumber = getImageNumber(for: divisionMeta.divisionId)
        let imageURL = URL(string: "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank\(imageNumber)_m.png")
        rankImageView.kf.setImage(with: imageURL)
    }

    private func getImageNumber(for divisionId: Int) -> Int {
        switch divisionId {
        case 800: return 0
        case 900: return 1
        case 1000: return 2
        case 1100: return 3
        case 1200: return 4
        case 1300: return 5
        case 2000: return 6
        case 2100: return 7
        case 2200: return 8
        case 2300: return 9
        case 2400: return 10
        case 2500: return 11
        case 2600: return 12
        case 2700: return 13
        case 2800: return 14
        case 2900: return 15
        case 3000: return 16
        case 3100: return 17
        default: return 17 // 기본값으로 가장 낮은 등급 이미지 사용
        }
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
