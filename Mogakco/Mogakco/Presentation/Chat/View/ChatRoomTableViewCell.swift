//
//  ChatRoomTableViewCell.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return "\(self)" }
}

final class ChatRoomTableViewCell: UITableViewCell, Identifiable {
    
    static let cellHeight = 80.0
    
    private lazy var chatRoomImageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    private let chatRoomTitleLabel = UILabel().then {
        $0.text = "Swift 공부방"
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18.0, weight: .bold)
    }
    
    private let latestMessageLabel = UILabel().then {
        $0.text = "언제 만날까요"
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 12.0, weight: .regular)
    }
    
    private let latestMessageDateLabel = UILabel().then {
        $0.text = "오후 2:09"
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 12.0, weight: .light)
    }
    
    private let unreadMessageCountLabel = UILabel().then {
        $0.text = "3"
        $0.textAlignment = .center
        $0.backgroundColor = .green
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chatRoomImageView.layer.cornerRadius = chatRoomImageView.frame.width / 2.0
        unreadMessageCountLabel.layer.cornerRadius = unreadMessageCountLabel.frame.width / 2.0
        unreadMessageCountLabel.layer.masksToBounds = true
    }
    
    private func layout() {
        layoutEntireStackView()
    }
    
    private func layoutEntireStackView() {
        let stackView = makeEntireStackView()
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }
    }
    
    private func makeEntireStackView() -> UIStackView {
        let arrangedSubviews = [chatRoomImageView, makeEntireLabelStackView()]
        
        chatRoomImageView.snp.makeConstraints {
            $0.width.equalTo(chatRoomImageView.snp.height)
        }
        
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 8.0
        }
    }
    
    private func makeEntireLabelStackView() -> UIStackView {
        let arrangedSubviews = [makeTopLabelStackView(), makeBottomLabelStackView()]
        
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .vertical
            $0.spacing = 4.0
        }
    }
    
    private func makeTopLabelStackView() -> UIStackView {
        let arrangedSubviews = [chatRoomTitleLabel, latestMessageDateLabel]
        
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
    }
    
    private func makeBottomLabelStackView() -> UIStackView {
        let arrangedSubviews = [latestMessageLabel, unreadMessageCountLabel]
        
        unreadMessageCountLabel.snp.makeConstraints {
            $0.width.equalTo(unreadMessageCountLabel.snp.height)
        }
 
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
    }
    
}
