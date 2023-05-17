//
//  AppDelegate.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 02/01/2022.
//

import UIKit
import IQKeyboardManagerSwift
import LanguageManager_iOS
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LanguageManager.shared.defaultLanguage = .en
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        Thread.sleep(forTimeInterval: 1)
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("dbfd87e2-dcf9-402d-a7ae-afba14379cb1")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        return true
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("PUSH NOTIFICATION is coming")
        let state: UIApplication.State = UIApplication.shared.applicationState
        let inBackground = state == .background
        let dizionario = userInfo["aps"] as! NSDictionary
        let alert = dizionario["alert"] as! NSDictionary
        let body = alert["body"] as? String ?? ""
        let badge = dizionario["badge"] as Any
        let targetContentId = dizionario["target-content-id"] as? String ?? ""
        let type = dizionario["category"] as? String ?? ""
        Shared.shared.notificationType = type
        Shared.shared.notificationId = targetContentId
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataNotification"), object: nil)
        
    }
    
}

