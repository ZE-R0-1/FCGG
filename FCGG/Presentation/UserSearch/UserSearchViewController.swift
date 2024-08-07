//
//  SearchResultView.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class UserSearchViewController: UIViewController {
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "구단주명"
        field.font = UIFont.systemFont(ofSize: 18)
        field.borderStyle = .none
        field.returnKeyType = .search
        return field
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let userInfoView = UserInfoView()
    private let divisionTitleLabel = UILabel()
    private let divisionsScrollView = UIScrollView()
    private let divisionsStackView = UIStackView()
    
    private let viewModel: UserSearchViewModel
    private let disposeBag = DisposeBag()
    
    private var searchContainerCenterYConstraint: NSLayoutConstraint?
    private var searchContainerTopConstraint: NSLayoutConstraint?
    
    init(viewModel: UserSearchViewModel) {
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
        view.backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1.0)
        
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchButton)
        searchContainerView.addSubview(searchField)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(userInfoView)
        contentView.addSubview(divisionTitleLabel)
        contentView.addSubview(divisionsScrollView)
        divisionsScrollView.addSubview(divisionsStackView)
        
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        divisionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        divisionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        divisionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainerCenterYConstraint = searchContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        searchContainerTopConstraint = searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        searchContainerTopConstraint?.isActive = false
        
        NSLayoutConstraint.activate([
            searchContainerCenterYConstraint!,
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -15),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            
            searchField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            searchField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
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
            
            divisionsScrollView.topAnchor.constraint(equalTo: divisionTitleLabel.bottomAnchor, constant: 10),
            divisionsScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divisionsScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divisionsScrollView.heightAnchor.constraint(equalToConstant: 120),
            divisionsScrollView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
            
            divisionsStackView.topAnchor.constraint(equalTo: divisionsScrollView.topAnchor),
            divisionsStackView.leadingAnchor.constraint(equalTo: divisionsScrollView.leadingAnchor),
            divisionsStackView.trailingAnchor.constraint(equalTo: divisionsScrollView.trailingAnchor),
            divisionsStackView.bottomAnchor.constraint(equalTo: divisionsScrollView.bottomAnchor),
            divisionsStackView.heightAnchor.constraint(equalTo: divisionsScrollView.heightAnchor)
        ])
        
        divisionTitleLabel.text = "최고 등급"
        divisionTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        userInfoView.isHidden = true
        divisionTitleLabel.isHidden = true
        divisionsScrollView.isHidden = true
        
        divisionsScrollView.showsHorizontalScrollIndicator = false
        divisionsScrollView.alwaysBounceHorizontal = true
        divisionsScrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 좌우 여백 추가
        
        divisionsStackView.axis = .horizontal
        divisionsStackView.alignment = .fill
        divisionsStackView.distribution = .equalSpacing
    }
    
    private func bindViewModel() {
        searchButton.rx.tap
            .withLatestFrom(searchField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.animateSearchToTop()
            })
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.user
            .drive(onNext: { [weak self] user in
                self?.userInfoView.configure(with: user)
                self?.configureDivisions(with: user.maxDivisions)
                self?.showUserInfo()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureDivisions(with divisions: [MaxDivision]) {
        divisionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let cardWidth: CGFloat = 150 // 카드 너비를 150으로 변경
        let cardSpacing: CGFloat = 20 // 카드 간 간격
        
        divisions.forEach { division in
            let divisionView = DivisionCardView()
            divisionView.configure(with: division)
            divisionView.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
            divisionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            divisionsStackView.addArrangedSubview(divisionView)
        }
        
        // 스택 뷰의 너비를 카드들의 총 너비로 설정
        let totalWidth = CGFloat(divisions.count) * (cardWidth + cardSpacing) - cardSpacing
        divisionsStackView.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
        
        // 스크롤 뷰의 content size 업데이트
        divisionsScrollView.contentSize = CGSize(width: totalWidth, height: divisionsScrollView.frame.height)
    }
    
    private func showUserInfo() {
        UIView.animate(withDuration: 0.3) {
            self.userInfoView.isHidden = false
            self.divisionTitleLabel.isHidden = false
            self.divisionsScrollView.isHidden = false
        }
    }
    
    private func animateSearchToTop() {
        UIView.animate(withDuration: 0.3) {
            self.searchContainerCenterYConstraint?.isActive = false
            self.searchContainerTopConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}
