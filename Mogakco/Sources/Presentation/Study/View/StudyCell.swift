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

final class StudyCell: UICollectionViewCell, Identifiable {
    
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
    
    // MARK: - Private
    
    private var state: StudyState = .open {
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
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: SFPro.bold.rawValue, size: 16)
        $0.text = "강남역 카페 모각코"
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private lazy var topStackView = UIStackView().then { stack in
        [stateLabel, titleLabel].forEach {
            stack.addArrangedSubview($0)
        }
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
    }
    
    private let dateView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "1월 20일 12시 30분"
        $0.imageView.image = UIImage(systemName: "calendar")
    }
    
    private let participantsView = StudyInfoView(frame: .zero).then {
        $0.textLabel.text = "2/3 참여"
        $0.imageView.image = Image.profileDefault
    }
    
    private lazy var midStackView = UIStackView().then { stack in
        [dateView, participantsView].forEach {
            stack.addArrangedSubview($0)
        }
        stack.spacing = 8
        stack.alignment = .fill
        stack.axis = .vertical
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .mogakcoFont.smallRegular
        $0.text = "오늘 강남역에서 모여서 모각코 하실분들 있을까요?"
        $0.numberOfLines = 2
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.setLineSpacing(spacing: 4)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let totalStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .leading
        $0.axis = .vertical
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setup(_ study: Study) {
        let currDate = Date().toInt(dateFormat: Format.compactDateFormat)
        let studyDateString = study.date.toCompactDateString()
        state = currDate < study.date ? .open : .close
        titleLabel.text = study.title
        dateView.textLabel.text = studyDateString
        participantsView.textLabel.text = "\(study.userIDs.count)/\(study.maxUserCount) 참여"
        contentLabel.text = study.content
        addCategoryHashtag(tag: study.category)
        addLanguageHashtag(tags: study.languages)
    }
    
    private func addCategoryHashtag(tag: String) {
        let label = UILabel()
        label.font = UIFont(name: SFPro.regular.rawValue, size: 12)
        label.text = Category(rawValue: tag)?.title
        hashtagStackView.addArrangedSubview(label)
    }
    
    private func addLanguageHashtag(tags: [String]) {
        tags.forEach {
            let label = UILabel()
            label.font = UIFont(name: SFPro.regular.rawValue, size: 12)
            label.text = Languages(rawValue: $0)?.title
            hashtagStackView.addArrangedSubview(label)
        }
    }
    
    private func layout() {
        [hashtagStackView, topStackView, midStackView, contentLabel].forEach {
            totalStackView.addArrangedSubview($0)
        }
        contentView.addSubview(totalStackView)
        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func configure() {
        backgroundColor = .mogakcoColor.backgroundDefault
        layer.cornerRadius = 10
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
        clipsToBounds = false
        addShadow(offset: CGSize(width: 1, height: 1), opacity: 0.3, radius: 5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
