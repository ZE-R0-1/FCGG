//
//  DivisionCardView.swift
//  FCGG
//
//  Created by USER on 8/6/24.
//

import UIKit
import Kingfisher
import FirebaseStorage

class DivisionCardView: UIView {
    private let imageView = UIImageView()
    private let modeLabel = UILabel()
    private let divisionNameLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        
        addSubview(imageView)
        addSubview(modeLabel)
        addSubview(divisionNameLabel)
        addSubview(dateLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        divisionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            modeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            modeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            divisionNameLabel.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 4),
            divisionNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: divisionNameLabel.bottomAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        modeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        divisionNameLabel.font = .systemFont(ofSize: 12)
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .systemGray
    }
    
    func configure(with maxDivision: MaxDivision) {
        modeLabel.text = maxDivision.matchTypeDesc
        divisionNameLabel.text = maxDivision.divisionName
        dateLabel.text = maxDivision.achievementDate
        
        loadImage(for: maxDivision.division)
    }
    
    private func loadImage(for division: Int) {
        let imagePath = "rankImage/\(division).png"
        
        print("Attempting to load image from path: \(imagePath)")
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://fcgg-7ef34.appspot.com")
        let imageRef = storageRef.child(imagePath)
        
        print("Full storage path: \(imageRef.fullPath)")
        
        imageRef.downloadURL { [weak self] (url, error) in
            if let error = error as NSError? {
                print("Error getting download URL for division '\(division)':")
                print("Error domain: \(error.domain)")
                print("Error code: \(error.code)")
                print("Error description: \(error.localizedDescription)")
            }
            
            guard let downloadURL = url else {
                print("Download URL is nil for division '\(division)'")
                return
            }
            
            print("Successfully got download URL: \(downloadURL)")
            
            DispatchQueue.main.async {
                self?.imageView.kf.setImage(with: downloadURL)
            }
        }
    }
}
