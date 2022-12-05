//
//  AppDelegate.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/07.
//

import UIKit

import FirebaseCore
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        appearance()
        DIContainer.shared.inject()
        
        return true
    }
    
    private func appearance() {
        UINavigationBar.appearance().tintColor = .mogakcoColor.typographyPrimary
        
        UILabel.appearance().textColor = .mogakcoColor.typographyPrimary
        
        UITextField.appearance().tintColor = .mogakcoColor.primaryDefault
        UITextField.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextField.appearance().backgroundColor = .mogakcoColor.backgroundSecondary
        UITextField.appearance().layer.borderColor = UIColor.mogakcoColor.semanticSuccess?.cgColor
        
        UITextView.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextView.appearance().backgroundColor = .mogakcoColor.backgroundSecondary
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.backgroundSecondary?.cgColor
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.backgroundSecondary?.cgColor
//        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.semanticSuccess?.cgColor
        UITextView.appearance().tintColor = .mogakcoColor.primaryDefault
        
        UICollectionView.appearance().backgroundColor = .mogakcoColor.backgroundDefault
        UICollectionViewCell.appearance().backgroundColor = .mogakcoColor.backgroundSecondary
        UICollectionViewCell.appearance().layer.borderColor = UIColor.mogakcoColor.borderDefault?.cgColor
    }
    
}
