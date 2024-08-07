//
//  UserDetailViewController.swift
//  FCGG
//
//  Created by USER on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let userInfoView = UserInfoView()
    private let divisionTitleLabel = UILabel()
    private let divisionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 100) // 적절한 크기로 조정
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let viewModel: UserDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(userInfoView)
        contentView.addSubview(divisionTitleLabel)
        contentView.addSubview(divisionsCollectionView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        divisionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        divisionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            userInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            divisionTitleLabel.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20),
            divisionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divisionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            divisionsCollectionView.topAnchor.constraint(equalTo: divisionTitleLabel.bottomAnchor, constant: 10),
            divisionsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divisionsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divisionsCollectionView.heightAnchor.constraint(equalToConstant: 120), // 적절한 높이로 조정
            divisionsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        divisionTitleLabel.text = "최고 등급"
        divisionTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        divisionsCollectionView.register(DivisionCardCell.self, forCellWithReuseIdentifier: "DivisionCardCell")
    }
    
    private func bindViewModel() {
        viewModel.user
            .drive(onNext: { [weak self] user in
                self?.userInfoView.configure(with: user)
            })
            .disposed(by: disposeBag)

        viewModel.maxDivisions
            .drive(divisionsCollectionView.rx.items(cellIdentifier: "DivisionCardCell", cellType: DivisionCardCell.self)) { _, division, cell in
                cell.configure(with: division)
            }
            .disposed(by: disposeBag)
    }
}

extension UserDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100) // 적절한 크기로 조정
    }
}

class DivisionCardCell: UICollectionViewCell {
    private let cardView = DivisionCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with division: MaxDivision) {
        cardView.configure(with: division)
    }
}
