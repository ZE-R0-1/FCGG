//
//  HomeViewController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.returnKeyType = .search
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let searchResultView: SearchResultView = {
        let view = SearchResultView()
        view.isHidden = true
        return view
    }()
    
    private var searchContainerCenterYConstraint: NSLayoutConstraint?
    private var searchContainerTopConstraint: NSLayoutConstraint?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchButton)
        view.addSubview(searchResultView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainerCenterYConstraint = searchContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        searchContainerTopConstraint = searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        searchContainerTopConstraint?.isActive = false
        
        NSLayoutConstraint.activate([
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 50),
            searchContainerCenterYConstraint!,
            
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60),
            
            searchResultView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
            searchResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        Observable.merge(
            searchButton.rx.tap.asObservable(),
            searchTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
        )
        .withLatestFrom(searchTextField.rx.text.orEmpty)
        .filter { !$0.isEmpty }
        .do(onNext: { [weak self] _ in
            self?.animateSearchContainerToTop()
        })
        .bind(to: viewModel.searchQuery)
        .disposed(by: disposeBag)
        
        viewModel.searchResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userInfo, rankInfos, matches in
                self?.showSearchResult(for: userInfo, rankInfos: rankInfos, matches: matches)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func animateSearchContainerToTop() {
        UIView.animate(withDuration: 0.3) {
            self.searchContainerCenterYConstraint?.isActive = false
            self.searchContainerTopConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSearchResult(for userInfo: UserBasicInfo, rankInfos: [(MatchType, MaxDivision, DivisionMeta)], matches: [String: [String]]) {
        searchResultView.isHidden = false
        searchResultView.configure(
            nickname: userInfo.nickname,
            level: userInfo.level,
            rankInfos: rankInfos,
            matches: matches
        )
    }
}
