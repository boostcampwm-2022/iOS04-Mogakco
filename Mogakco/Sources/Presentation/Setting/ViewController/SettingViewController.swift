//
//  SettingViewController.swift
//  Mogakco
//
//  Created by 오국원 on 2022/12/05.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingViewController: ViewController {
    
    enum SettingMenu: String, CaseIterable {
        
        case logout = "로그아웃"
        case withdraw = "회원탈퇴"

        init(row: Int) {
            switch row {
            case 0: self = .logout
            default: self = .withdraw
            }
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )
        $0.rowHeight = SettingTableViewCell.Constant.cellHeight
        $0.backgroundColor = .mogakcoColor.backgroundDefault
    }
    
    private let logoutDidTap = PublishSubject<Void>()
    private let withdrawDidTap = PublishSubject<Void>()
    
    var viewModel: SettingViewModel?
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bind() {
        
        let input = SettingViewModel.Input(
            logoutDidTap: logoutDidTap.asObservable(),
            withdrawDidTap: withdrawDidTap.asObservable(),
            backButtonDidTap: backButton.rx.tap.asObservable()
        )
        
        _ = viewModel?.transform(input: input)
        
        Driver<[SettingMenu]>
            .just(SettingMenu.allCases)
            .drive(tableView.rx.items) { tableView, index, menu in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? SettingTableViewCell else { return UITableViewCell() }
                cell.titleLabel.text = menu.rawValue
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { SettingMenu(row: $0.row) }
            .subscribe(onNext: { [weak self] row in
                switch row {
                case .logout:
                    self?.alert(
                        title: "로그아웃",
                        message: "로그아웃 하시겠어요?",
                        actions: [
                            .cancel(),
                            .destructive(
                                title: "확인",
                                handler: { [weak self] _ in self?.logoutDidTap.onNext(()) }
                            )
                        ]
                    )
                case .withdraw:
                    self?.withdrawDidTap.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutNavigationBar()
        layoutTableView()
    }
    
    private func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "설정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func layoutNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .mogakcoColor.backgroundDefault
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.standardAppearance = navBarAppearance
        navigationItem.scrollEdgeAppearance = navBarAppearance
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
}
