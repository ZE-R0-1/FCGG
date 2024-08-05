//
//  MatchDetailViewController.swift
//  FCGG
//
//  Created by USER on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa

class MatchDetailViewController: UIViewController {
    private let viewModel: MatchDetailViewModel
    private let disposeBag = DisposeBag()

    // UI 컴포넌트들...

    init(viewModel: MatchDetailViewModel) {
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
        // UI 컴포넌트 설정
    }

    private func bindViewModel() {
        viewModel.matchDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                self?.updateUI(with: detail)
            })
            .disposed(by: disposeBag)

        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }

    private func updateUI(with detail: MatchDetail) {
        // UI 업데이트
    }

    private func showError(_ error: Error) {
        // 에러 표시
    }
}
