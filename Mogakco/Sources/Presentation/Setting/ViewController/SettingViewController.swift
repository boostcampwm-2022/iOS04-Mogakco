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
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: SettingTableViewCell.identifier
        )
        $0.rowHeight = SettingTableViewCell.Constant.cellHeight
        $0.backgroundColor = .mogakcoColor.backgroundDefault
    }
    
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
            logoutDidTap: tableView.rx.itemSelected.asObservable(),
            withdrawDidTap: tableView.rx.itemSelected.asObservable(),
            backButtonDidTap: backButton.rx.tap.asObservable()
        )
        
        let _ = viewModel?.transform(input: input)
        
        viewModel?.settings
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tableView, index, menu in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingTableViewCell.identifier,
                    for: IndexPath(row: index, section: 0)) as? SettingTableViewCell else { return UITableViewCell() }
                cell.titleLabel.text = menu
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        layoutTableView()
    }
    
    private func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "설정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
}
