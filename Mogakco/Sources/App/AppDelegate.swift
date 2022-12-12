//
//  AppDelegate.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/07.
//

import UIKit

import FirebaseCore
import FirebaseMessaging
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var keyChainMananger: KeychainManagerProtocol?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        DIContainer.shared.inject()
        keyChainMananger = DIContainer.shared.container.resolve(KeychainManagerProtocol.self)
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        requestNotificationAuthorization()
        application.registerForRemoteNotifications()

        appearance()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait // 세로방향 고정
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

	private func appearance() {
        navigationBarAppearance()
        tapBarAppearance()
        labelAppearance()
        textFieldAppearance()
        textViewAppearance()
        collectionViewAppearance()
        tableViewAppearance()
    }
    
    private func navigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mogakcoColor.typographyPrimary ?? UIColor.white]
        navigationBarAppearance.backgroundColor = .mogakcoColor.backgroundDefault
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func tapBarAppearance() {
        UITabBar.appearance().tintColor = .mogakcoColor.primaryDefault
        UITabBar.appearance().barTintColor = .mogakcoColor.primaryThird
    }
    
    private func labelAppearance() {
        UILabel.appearance().textColor = .mogakcoColor.typographyPrimary
    }
    
    private func textFieldAppearance() {
        UITextField.appearance().tintColor = .mogakcoColor.primaryDefault
        UITextField.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextField.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UITextField.appearance().layer.borderColor = UIColor.mogakcoColor.semanticSuccess?.cgColor
    }
    
    private func textViewAppearance() {
        UITextView.appearance().textColor = .mogakcoColor.typographyPrimary
        UITextView.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.primarySecondary?.cgColor
        UITextView.appearance().layer.borderColor = UIColor.mogakcoColor.primarySecondary?.cgColor
        UITextView.appearance().tintColor = .mogakcoColor.primaryDefault
    }
    
    private func collectionViewAppearance() {
        UICollectionView.appearance().backgroundColor = .mogakcoColor.backgroundDefault
        UICollectionViewCell.appearance().backgroundColor = .mogakcoColor.primarySecondary
        UICollectionViewCell.appearance().layer.borderColor = UIColor.mogakcoColor.primaryDefault?.cgColor
    }
    
    private func tableViewAppearance() {
        UITableView.appearance().backgroundColor = .mogakcoColor.backgroundDefault
        UITableViewCell.appearance().backgroundColor = .mogakcoColor.primarySecondary
    }
}

// MARK: MessagingDelegate

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken,
              let fcmTokenData = fcmToken.data(using: .utf8) else {
            print("fcm token not exists.")
            return
        }
        _ = keyChainMananger?.save(key: .fcmToken, data: fcmTokenData)
        print("fcmToken:", fcmToken)
    }
}

// MARK: Notification

extension AppDelegate : UNUserNotificationCenterDelegate {
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print(error)
                }
                print("notification authorizted: \(granted)")
            }
        )
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        ChatListViewModel.reload.onNext(())
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
