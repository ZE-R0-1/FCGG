//
//  SearchResultView.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class UserSearchViewController: UIViewController, UIScrollViewDelegate {
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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = 100
        table.alpha = 0 // 초기에는 숨김
        return table
    }()
    
    private let viewModel: UserSearchViewModel
    private let disposeBag = DisposeBag()
    
    private var searchContainerCenterYConstraint: NSLayoutConstraint?
    private var searchContainerTopConstraint: NSLayoutConstraint?
    
    private var currentUser: User?

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
        view.addSubview(tableView)
        
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
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
            .do(onNext: { [weak self] user in
                self?.currentUser = user
                self?.showTableView()
                self?.tableView.reloadData()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func animateSearchToTop() {
        UIView.animate(withDuration: 0.3) {
            self.searchContainerCenterYConstraint?.isActive = false
            self.searchContainerTopConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func showTableView() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}

extension UserSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell,
              let user = currentUser else {
            return UITableViewCell()
        }
        
        cell.configure(with: user)
        return cell
    }
}
