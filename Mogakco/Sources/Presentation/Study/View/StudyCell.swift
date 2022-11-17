//
//  StudyCell.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class StudyCell: UITableViewCell, Identifiable {
    
    enum StudyState: String {
        case open = "모집중"
        case close = "모집완료"
        
        var color: UIColor {
            switch self {
            case .open:
                return .mogakcoColor.primaryDefault ?? UIColor.systemGreen
            case.close:
                return .mogakcoColor.typographySecondary ?? UIColor.systemGray
            }
        }
    }
    
    var state: StudyState = .open {
        didSet {
            stateLabel.text = state.rawValue
            stateLabel.textColor = state.color
        }
    }
    
    private let hashtagStackView = UIStackView().then {
        $0.spacing = 5
        $0.alignment = .fill
        $0.axis = .horizontal
    }
    
    private let stateLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.textColor = .mogakcoColor.primaryDefault
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.text = "강남역 카페 모각코"
        $0.textColor = .mogakcoColor.typographyPrimary
    }
    
    private lazy var topStackView = UIStackView().then { stack in
        [stateLabel, titleLabel, UIView()].forEach {
            stack.addArrangedSubview($0)
        }
        stack.spacing = 5
        stack.alignment = .fill
        stack.axis = .horizontal
    }
    
    private let dateView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "1월 20일 12시 30분"
        $0.imageView.image = UIImage(systemName: "calendar")
    }
    
    private let participantsView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "2/3 참여"
        $0.imageView.image = UIImage(systemName: "person.2")
    }
    
    private lazy var midStackView = UIStackView().then { stack in
        [dateView, participantsView].forEach {
            stack.addArrangedSubview($0)
        }
        stack.spacing = 6
        stack.alignment = .fill
        stack.axis = .vertical
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .mogakcoFont.smallRegular
        $0.text = "오늘 강남역에서 모여서 모각코 하실분들 있을까요?"
        $0.textColor = .mogakcoColor.typographyPrimary
    }
    
    private let totalStackView = UIStackView().then {
        $0.spacing = 7
        $0.alignment = .fill
        $0.axis = .vertical
    }
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func layout() {
        [hashtagStackView, topStackView, midStackView, contentLabel].forEach {
            totalStackView.addArrangedSubview($0)
        }
        addSubview(totalStackView)
        totalStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        selectionStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
        addShadow(offset: CGSize(width: 1, height: 1))
    }
}
