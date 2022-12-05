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
        DIContainer.shared.inject()
        UINavigationBar.appearance().tintColor = UIColor.mogakcoColor.typographyPrimary
        return true
    }
}
