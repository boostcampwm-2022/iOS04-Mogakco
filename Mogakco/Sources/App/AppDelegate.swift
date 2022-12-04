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
        DependencyInjector.shared.inject()
        return true
    }
}
