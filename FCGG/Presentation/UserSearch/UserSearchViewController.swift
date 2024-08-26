//
//  UserSearchViewController.swift
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
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        tableView.register(MatchSummaryCell.self, forCellReuseIdentifier: "MatchCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
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
        setupKeyboardObservers()
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
        
        searchField.delegate = self
        searchField.returnKeyType = .search
    }
    
    private func setupConstraints() {
        [searchContainerView, searchButton, searchField, scrollView, contentView, userInfoView, divisionTitleLabel, divisionsScrollView, divisionsStackView, matchHistoryTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchContainerCenterYConstraint = searchContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        searchContainerTopConstraint = searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        searchContainerTopConstraint?.isActive = false
        
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
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
            scrollViewBottomConstraint!,
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            userInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
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
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.searchContainerCenterYConstraint?.constant = -(self.view.bounds.height / 2 - keyboardHeight - self.searchContainerView.bounds.height / 2)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.searchContainerCenterYConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        searchButton.rx.tap
            .do(onNext: { [weak self] in
                self?.view.endEditing(true)
                self?.animateSearchToTop()
            })
            .withLatestFrom(searchField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
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
            self?.updateTableViewHeight()
            self?.updateScrollViewContentSize()
        }
    }
    
    private func showMatchHistory() {
        UIView.animate(withDuration: 0.3) {
            self.matchHistoryTableView.isHidden = false
        }
    }
    
    private func updateTableViewHeight() {
        matchHistoryTableView.layoutIfNeeded()
        let height = matchHistoryTableView.contentSize.height
        matchHistoryTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                matchHistoryTableView.removeConstraint(constraint)
            }
        }
        matchHistoryTableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func updateScrollViewContentSize() {
        DispatchQueue.main.async {
            self.scrollView.contentSize = self.contentView.bounds.size
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentMatchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchSummaryCell else {
            return UITableViewCell()
        }
        
        let match = viewModel.currentMatchHistory[indexPath.row]
        if let userNickname = viewModel.currentUser?.nickname {
            cell.configure(with: match, userNickname: userNickname)
        } else {
            cell.configure(with: match, userNickname: "???")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 // 또는 원하는 높이로 설정
    }
}

// MARK: - UITextFieldDelegate

extension UserSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton.sendActions(for: .touchUpInside)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트 필드 편집이 시작될 때 추가 동작이 필요한 경우 여기에 구현
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드 편집이 끝날 때 추가 동작이 필요한 경우 여기에 구현
    }
}
