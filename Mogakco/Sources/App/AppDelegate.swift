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
        
        UITabBar.appearance().tintColor = .mogakcoColor.primaryDefault
        UITabBar.appearance().barTintColor = .mogakcoColor.primaryThird
        
        UILabel.appearance().textColor = .mogakcoColor.typographyPrimary
        
        UITextField.appearance().tintColor = .mogakcoColor.primaryDefault
        UITextField.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextField.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UITextField.appearance().layer.borderColor = UIColor.mogakcoColor.semanticSuccess?.cgColor
        
        UITextView.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextView.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.primarySecondary?.cgColor
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.primarySecondary?.cgColor
        UITextView.appearance().tintColor = .mogakcoColor.primaryDefault
        
        UICollectionView.appearance().backgroundColor = .mogakcoColor.backgroundDefault
        UICollectionViewCell.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UICollectionViewCell.appearance().layer.borderColor = UIColor.mogakcoColor.primaryDefault?.cgColor
        
        UITableViewCell.appearance().backgroundColor = .mogakcoColor.primarySecondary
    }
    
}
