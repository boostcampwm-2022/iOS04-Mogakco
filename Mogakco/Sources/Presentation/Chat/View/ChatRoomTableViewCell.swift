//
//  ChatRoomTableViewCell.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class ChatRoomTableViewCell: UITableViewCell, Identifiable {
    
    enum Constant {
        static let cellHeight = 80.0
        static let noUsersTitle = "유저가 존재하지 않아요!"
        static let noMessageTitle = "아직 채팅 메세지가 없어요!"
    }
    
    private let chatRoomUsersImageView = ChatRoomUsersImageView()
    
    private let chatRoomTitleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.mediumBold
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
    }
    
    private let latestMessageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let latestMessageDateLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = UIFont.mogakcoFont.smallRegular
        $0.textColor = UIColor.mogakcoColor.typographySecondary
    }
    
    private let unreadMessageCountLabel = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.mogakcoColor.primarySecondary
        $0.font = UIFont.mogakcoFont.caption
        $0.textColor = UIColor.mogakcoColor.typographyPrimary
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
        configureUnreadMessageCountLabelCornerRadius()
    }
    
    func configure(chatRoom: ChatRoom) {
        chatRoomUsersImageView.configure(
            imageURLs: (chatRoom.users ?? [])
                .compactMap { $0.profileImageURLString }
                .compactMap { URL(string: $0) }
            )
        chatRoomTitleLabel.text = chatRoom.users?.map { $0.name }.joined(separator: ", ") ?? Constant.noUsersTitle
        latestMessageLabel.text = chatRoom.latestChat?.message ?? Constant.noMessageTitle
        
        latestMessageDateLabel.text = chatRoom.latestChat?.date.toString
            .toDate(dateFormat: Format.compactDateFormat)?.relativeTime ?? ""
        
        let unreadChatCount = chatRoom.unreadChatCount ?? 0
        unreadMessageCountLabel.isHidden = unreadChatCount == 0
        unreadMessageCountLabel.text = String(unreadChatCount)
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
        let arrangedSubviews = [chatRoomUsersImageView, makeEntireLabelStackView()]
        
        chatRoomUsersImageView.snp.makeConstraints {
            $0.width.equalTo(chatRoomUsersImageView.snp.height)
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
        
        latestMessageLabel.snp.makeConstraints {
            $0.height.equalTo(16.0)
        }
        unreadMessageCountLabel.snp.makeConstraints {
            $0.width.equalTo(unreadMessageCountLabel.snp.height)
        }
 
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .horizontal
            $0.spacing = 4.0
        }
    }
    
    private func configureUnreadMessageCountLabelCornerRadius() {
        unreadMessageCountLabel.layer.cornerRadius = unreadMessageCountLabel.frame.width / 2.0
        unreadMessageCountLabel.layer.masksToBounds = true
    }
}
