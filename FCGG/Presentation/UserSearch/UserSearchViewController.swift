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
    
    // MARK: - Properties
    
    private let viewModel: UserSearchViewModel
    private let disposeBag = DisposeBag()
    
    private var searchContainerCenterYConstraint: NSLayoutConstraint?
    private var searchContainerTopConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    
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
    private let divisionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 등급"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let divisionsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return scrollView
    }()
    
    private let divisionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let matchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MatchInfoView.self, forCellReuseIdentifier: "MatchCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(viewModel: UserSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    
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
        
        contentView.addSubview(matchHistoryTableView)
        
        setupConstraints()
        
        userInfoView.isHidden = true
        divisionTitleLabel.isHidden = true
        divisionsScrollView.isHidden = true
        matchHistoryTableView.isHidden = true
        
        matchHistoryTableView.dataSource = self
        matchHistoryTableView.delegate = self
        
        // 스크롤 뷰 설정
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupConstraints() {
        [searchContainerView, searchButton, searchField, scrollView, contentView, userInfoView, divisionTitleLabel, divisionsScrollView, divisionsStackView, matchHistoryTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            
            matchHistoryTableView.topAnchor.constraint(equalTo: divisionsScrollView.bottomAnchor, constant: 20),
            matchHistoryTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            matchHistoryTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            matchHistoryTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        // contentView의 높이를 동적으로 조정
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
    }
    
    // MARK: - ViewModel Binding
    
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
                self?.showUserInfo()
            })
            .disposed(by: disposeBag)
        
        viewModel.maxDivisions
            .drive(onNext: { [weak self] divisions in
                self?.configureDivisions(with: divisions)
                self?.showMaxDivision()
            })
            .disposed(by: disposeBag)
        
        viewModel.matchHistory
            .drive(onNext: { [weak self] _ in
                self?.updateMatchHistory()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func configureDivisions(with divisions: [MaxDivision]) {
        divisionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        divisions.forEach { division in
            let divisionView = DivisionCardView()
            divisionView.configure(with: division)
            divisionView.widthAnchor.constraint(equalToConstant: 140).isActive = true
            divisionsStackView.addArrangedSubview(divisionView)
        }
        
        let totalWidth = CGFloat(divisions.count) * 155 // 140 (width) + 15 (spacing)
        divisionsScrollView.contentSize = CGSize(width: totalWidth, height: divisionsScrollView.frame.height)
    }
    
    private func showUserInfo() {
        UIView.animate(withDuration: 0.3) {
            self.userInfoView.isHidden = false
        }
    }
    
    private func showMaxDivision() {
        UIView.animate(withDuration: 0.3) {
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
    
    private func updateMatchHistory() {
        DispatchQueue.main.async { [weak self] in
            self?.matchHistoryTableView.reloadData()
            self?.showMatchHistory()
            self?.updateContentSize()
        }
    }
    
    private func updateContentSize() {
        let contentHeight = userInfoView.frame.maxY +
        divisionTitleLabel.frame.height +
        divisionsScrollView.frame.height +
        matchHistoryTableView.contentSize.height +
        100  // 추가 여백
        
        contentView.frame.size.height = max(contentHeight, scrollView.frame.height)
        scrollView.contentSize = contentView.frame.size
    }
    
    private func showMatchHistory() {
        UIView.animate(withDuration: 0.3) {
            self.matchHistoryTableView.isHidden = false
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.currentMatchHistory.count
        print("Number of rows in match history: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchInfoView else {
            print("Failed to dequeue MatchInfoView")
            return UITableViewCell()
        }
        
        let match = viewModel.currentMatchHistory[indexPath.row]
        cell.configure(with: match)
        return cell
    }
}
