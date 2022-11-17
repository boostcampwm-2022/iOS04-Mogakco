//
//  StudyListViewController.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class StudyListViewController: ViewController {
    
    private let headerView = TitleHeaderView().then {
        $0.setTitle("모각코")
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(StudyCell.self, forCellReuseIdentifier: StudyCell.identifier)
        $0.rowHeight = 120
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
    }
    
    private weak var coordinator: StudyTabCoordinatorProtocol?
    
    init(coordinator: StudyTabCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layout() {
        layoutHeaderView()
        layoutTableView()
    }
    
    private func layoutHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(68.0)
        }
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
    }
}

extension StudyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudyCell.identifier,
            for: indexPath
        ) as? StudyCell else {
            return UITableViewCell()
        }
        
        cell.state = .open
        return cell
    }
}

extension StudyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showStudyDetail()
    }
}
