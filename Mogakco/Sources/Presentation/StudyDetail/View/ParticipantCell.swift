//
//  ParticipantCell.swift
//  Mogakco
//
//  Created by 이주훈 on 2022/11/15.
//

import UIKit

import RxSwift
import Alamofire
import Then

final class ParticipantCell: UICollectionViewCell, Identifiable {
    static let width = 110
    static let height = 130
    
    override func prepareForReuse() {
        layout()
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .mogakcoFont.mediumBold
        $0.textColor = .mogakcoColor.typographyPrimary
        $0.text = "default User name"
    }
    
    private let userDescriptionLabel = UILabel().then {
        $0.font = .mogakcoFont.smallRegular
        $0.textColor = .mogakcoColor.typographySecondary
        $0.text = "default user desctiption"
    }
    
    func layout() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
        
        addShadow(
            offset: CGSize(width: 30, height: 30),
            color: .gray
        )
    }
    
    func setInfo(imageURLString: String, name: String, description: String) {
        
        // TODO: Image 처리 필요
        imageView.image = UIImage(systemName: "person.crop.circle")
        userNameLabel.text = name
        userDescriptionLabel.text = description
    }
}
