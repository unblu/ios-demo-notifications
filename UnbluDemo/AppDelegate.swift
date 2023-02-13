//
//  AppDelegate.swift
//

import Foundation
import UIKit
import UnbluCoreSDK
import UnbluFirebaseNotificationModule
import UnbluMobileCoBrowsingModule
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var instance: AppDelegate! = nil

    var callModule: UnbluCallModuleApi?
    var unbluVisitor: UnbluVisitorClient?
    var mobileCoBrowsingModule: UnbluMobileCoBrowsingModuleApi?
    
    var userNotificationCenter = NotificationCenterDelegate()
    var coordinator: FirebaseDelegate?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.instance = self
        if  createClient() {
            coordinator?.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
     
    // swizzling disabled (Info.plist FirebaseAppDelegateProxyEnabled: false)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken;
    }

    //Called when received a background remote notification.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        do {
            // the notification will be decrypted and delivered as a local notification
            try UnbluNotificationApi.instance.handleRemoteNotification(userInfo: userInfo,withCompletionHandler: {_ in
                // if it is endCall or readMessage notifications (silent)
            })
        } catch {
            // if this not an unblu notification , call default implementation
            coordinator?.on_application(application, didReceiveRemoteNotification: userInfo)
        }
    }

    //Called when received a background remote notification.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        do {
            // Important! if the notification version is encrypted use this method instead 'handleRemoteNotification(userInfo:  [AnyHashable: Any])'
            //the notification will be decrypted and delivered as a local notification
            try UnbluNotificationApi.instance.handleRemoteNotification(userInfo: userInfo,withCompletionHandler: {_ in
                // if it is endCall or readMessage notifications (silent)
            })
        } catch {
            // if this not an unblu notification , call default implementation
            coordinator?.on_application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
}


extension AppDelegate {
    
    func createClient() -> Bool {
        // Set Icon for CallKit UI
        // UnbluClientConfiguration.callKitProviderIconResourceName = "go-to-app"

        //1. Register modules
        var config = createUnbluConfig()
        config.unbluPushNotificationVersion = .Encrypted

        callModule = UnbluCallModuleProvider.create()
        try! config.register(module: callModule!)
        callModule?.delegate = CallModuleDelegate()

        let mobileCoBrowsingModuleConfig = UnbluMobileCoBrowsingModuleConfiguration(enableCapturingPerformanceLogging: true)
        mobileCoBrowsingModule = UnbluMobileCoBrowsingModuleProvider.create(config: mobileCoBrowsingModuleConfig)
        try! config.register(module: mobileCoBrowsingModule!)
        mobileCoBrowsingModule?.delegate = CoBrowsingDelegate()

        //2 Set NotificationCenter delegate
        UNUserNotificationCenter.current().delegate = userNotificationCenter
        
        //3. Create client , register for PushKit notifications
        unbluVisitor = Unblu.createVisitorClient(withConfiguration: config)
        unbluVisitor?.logLevel = .verbose
        unbluVisitor?.enableDebugOutput = true
        unbluVisitor?.visitorDelegate = VisitorClientDelegate()
       
        //4. Init Firebase , register for Push notifications
        coordinator = FirebaseDelegate()
    
        return true
    }
    
    func createUnbluConfig() -> UnbluClientConfiguration {
        var configuration = UnbluClientConfiguration(unbluBaseUrl: "http://192.168.1.159:7777",
                                                     apiKey:  "MZsy5sFESYqU7MawXZgR_w",
                                                     preferencesStorage: UserDefaultsPreferencesStorage(),
                                                     fileDownloadHandler: UnbluDefaultFileDownloadHandler(),
                                                     externalLinkHandler: UnbluDefaultExternalLinkHandler())        
        return configuration
    }
    
    func getUnbluView() -> UIView {
        return unbluVisitor?.view ?? UIView()
    }
    
    func startUnbluView(_ pin: Int) {
        unbluVisitor?.isInitialized(success: { isInitialized in
            if !isInitialized {
                // Send APNs PushKit token and FCM token to the Unblu server
                self.unbluVisitor?.start { result in
                    switch result {
                    case .success:
                        if pin > 0 {
                            self.unbluVisitor?.joinConversation(pin: String(pin)) { result in
                                switch result {
                                case .success(let conversation):
                                    print("Joined conversation: \(conversation.id)")
                                case .failure(let error):
                                    print("Error while joining conversation: \(error)")
                                }
                            }
                        }
                        print("Unblu started")
                    case .failure(let error):
                        print("Unblu failed with error: \(error)")
                    }
                }
            }
        })
    }
}

