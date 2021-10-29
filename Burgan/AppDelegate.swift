//
//  AppDelegate.swift
//  Burgan
//
//  Created by 1st iMac on 12/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import LanguageManager_iOS
import Siren
import Firebase
import FirebaseDynamicLinks


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "hasRunBefore") {
            // Remove Keychain items here
            KeyChain.RemoveFromKeychain()
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
        }
        
        
        UserDefaults.standard.setValue("123456", forKey: "DeviceToken")
        
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
            
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        LanguageManager.shared.defaultLanguage = .deviceLanguage
        
        // Check for Auto updates
        if UserDefaults.standard.value(forKey: "AutoUpdateSwitch") != nil {
            manualExampleWithCompletionHandler()
        }
        
        // FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "com.appic.burgan"
        
        FirebaseApp.configure()
        
//        userDefaults.set("en", forKey: "AppleLanguage")
        
        return true
    }
    
    /// Rather than waiting for `didBecomeActive` state changes (e.g., app launching/relaunching),
    /// Siren's version checking and alert presentation methods will be triggered each time this method is called.
    func manualExampleWithCompletionHandler() {
        Siren.shared.wail(performCheck: .onDemand) { results in
            switch results {
            case .success(let updateResults):
                print("AlertAction ", updateResults.alertAction)
                print("Localization ", updateResults.localization)
                print("Model ", updateResults.model)
                print("UpdateType ", updateResults.updateType)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            print(dynamicLink)
            
            return true
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.window!.bounds
        visualEffectView.tag = 101
        self.window?.addSubview(visualEffectView)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        if let view : UIVisualEffectView = UIApplication.shared.keyWindow?.subviews.last?.viewWithTag(101) as? UIVisualEffectView {
            view.removeFromSuperview()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        
        completionHandler()
        
    }
    
    
    func registerForPushNotifications()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
            (granted,error) in
            if granted
            {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            } else {
            }
            
        }
    }
    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        AppConstants.UserData.deviceToken = token
        UserDefaults.standard.setValue(token, forKey: "DeviceToken")
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        print(userInfo)
    }
    
    
    
    
}

