//
//  ViewController.swift
//  FCGG
//
//  Created by USER on 7/24/24.
//

import RxSwift
import RxCocoa

// HomeViewModel은 HomeViewController의 데이터를 관리하고 비즈니스 로직을 처리합니다.
class HomeViewModel {
    private let searchPlayerUseCase: SearchPlayerUseCase
    // 비즈니스 로직을 실행하는 UseCase를 주입받습니다.
    // private let getMatchIDsUseCase: GetMatchIDsUseCase // 주석 처리된 다른 UseCase (현재 사용하지 않음)
    private let disposeBag = DisposeBag()
    
    // Input: 검색 쿼리를 입력받는 Subject
    let searchQuery = PublishSubject<String>()
    
    // Output: 검색 결과와 에러를 방출하는 Subjects
    let searchResult = PublishSubject<(UserBasicInfo, [MaxDivision], [MatchType], [DivisionMeta], [Int: [String]])>()
    let error = PublishSubject<Error>()
    
    // 초기화 메서드
    init(searchPlayerUseCase: SearchPlayerUseCase) {
        self.searchPlayerUseCase = searchPlayerUseCase
        // 입력에 대한 바인딩 설정
        bindInputs()
    }

    // 입력 바인딩 설정
    private func bindInputs() {
        // 검색 쿼리의 변경을 감지하여 UseCase를 통해 검색 수행
        searchQuery
            .flatMapLatest { [unowned self] query in
                // 쿼리로 플레이어 검색
                self.searchPlayerUseCase.execute(name: query)
                    .catch { error in
                        // 에러 발생 시 에러 Subject에 에러 방출
                        self.error.onNext(error)
                        return Observable.empty() // 에러가 발생하면 빈 Observable 반환
                    }
            }
            // 검색 결과를 searchResult Subject에 바인딩
            .bind(to: searchResult)
            .disposed(by: disposeBag) // DisposeBag에 추가하여 메모리 관리
    }
}
