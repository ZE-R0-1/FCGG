//
//  HomeViewController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

// HomeViewController는 사용자가 선수 정보를 검색하고 결과를 표시하는 화면을 관리합니다.
class HomeViewController: UIViewController {
    // ViewModel을 통해 데이터를 관리하고 뷰와 바인딩합니다.
    private let viewModel: HomeViewModel
    // RxSwift의 DisposeBag을 사용하여 메모리 관리를 합니다.
    private let disposeBag = DisposeBag()
    
    // 검색 입력 및 버튼을 포함한 컨테이너 뷰
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
    
    // 검색어를 입력받는 텍스트 필드
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.returnKeyType = .search
        return textField
    }()
    
    // 검색 버튼
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    // 검색 결과를 표시할 뷰
    private let searchResultView: SearchResultView = {
        let view = SearchResultView()
        view.isHidden = true // 초기에는 숨김
        return view
    }()
    
    // 검색 컨테이너 뷰의 위치를 제어할 제약조건 변수
    private var searchContainerCenterYConstraint: NSLayoutConstraint?
    private var searchContainerTopConstraint: NSLayoutConstraint?
    
    // ViewModel을 인자로 받는 초기화 메서드
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // NSCoder를 통한 초기화가 구현되지 않았음을 표시
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰가 로드될 때 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()  // 뷰를 설정하는 메서드 호출
        bindViewModel()  // ViewModel과 바인딩
    }
    
    // 뷰의 서브뷰와 제약조건을 설정하는 메서드
    private func setupView() {
        view.backgroundColor = .white
        
        // 서브뷰를 추가
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchButton)
        view.addSubview(searchResultView)
        
        // 오토 레이아웃 제약조건 설정
        setupConstraints()
    }
    
    // 오토 레이아웃 제약조건을 설정하는 메서드
    private func setupConstraints() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        
        // 컨테이너 뷰의 위치를 제어할 제약조건 설정
        searchContainerCenterYConstraint = searchContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        searchContainerTopConstraint = searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        searchContainerTopConstraint?.isActive = false
        
        // 서브뷰의 제약조건 활성화
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
    
    // ViewModel과의 바인딩을 설정하는 메서드
    private func bindViewModel() {
        // 검색 버튼 클릭 또는 텍스트 필드에서 Return 키 입력 시 검색 쿼리 전달
        Observable.merge(
            searchButton.rx.tap.asObservable(),
            searchTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
        )
        .withLatestFrom(searchTextField.rx.text.orEmpty)
        .filter { !$0.isEmpty }
        .do(onNext: { [weak self] _ in
            self?.animateSearchContainerToTop() // 검색 후 애니메이션 적용
        })
        .bind(to: viewModel.searchQuery)  // ViewModel의 searchQuery에 바인딩
        .disposed(by: disposeBag)
        
        // 검색 결과를 받아와서 화면에 표시
        viewModel.searchResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userInfo, divisions, matchTypes, divisionMetas, matches in
                self?.showSearchResult(for: userInfo, divisions: divisions, matchTypes: matchTypes, divisionMetas: divisionMetas, matches: matches)
            })
            .disposed(by: disposeBag)
        
        // 에러 발생 시 경고 메시지 표시
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    // 검색 컨테이너 뷰를 화면 상단으로 애니메이션 이동
    private func animateSearchContainerToTop() {
        UIView.animate(withDuration: 0.3) {
            self.searchContainerCenterYConstraint?.isActive = false
            self.searchContainerTopConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    // 알림을 띄우는 메서드
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // 검색 결과를 표시하는 메서드
    private func showSearchResult(for userInfo: UserBasicInfo, divisions: [MaxDivision], matchTypes: [MatchType], divisionMetas: [DivisionMeta], matches: [Int: [String]]) {
        searchResultView.isHidden = false
        
        // Division 정보를 포맷팅하는 클로저
        let formatDivision: (MaxDivision) -> String = { division in
            let matchTypeDesc = matchTypes.first(where: { $0.matchtype == division.matchType })?.desc ?? "Unknown"
            let divisionName = divisionMetas.first(where: { $0.divisionId == division.division })?.divisionName ?? "Unknown"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: division.achievementDate) ?? Date()
            dateFormatter.dateFormat = "yy.MM.dd HH시"
            let formattedDate = dateFormatter.string(from: date)
            return "역대 \(matchTypeDesc): \(divisionName) / \(formattedDate)"
        }
        
        // Division 정보를 포맷팅하여 문자열로 변환
        let formattedDivisions = divisions.map(formatDivision).joined(separator: "\n")
        
        // 매치 타입과 매치 ID를 포맷팅
        let formattedMatches: [(String, [String])] = matches.map { (matchType, matchIds) in
            let matchTypeDesc = matchTypes.first(where: { $0.matchtype == matchType })?.desc ?? "Unknown"
            return (matchTypeDesc, matchIds)
        }
        
        print("Formatted matches: \(formattedMatches)")
        
        // 검색 결과 뷰에 데이터 설정
        searchResultView.configure(
            nickname: userInfo.nickname,
            level: userInfo.level,
            rankInfo: formattedDivisions,
            matches: formattedMatches
        )
    }
}
