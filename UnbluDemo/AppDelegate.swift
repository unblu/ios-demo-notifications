//
//  AppDelegate.swift
//

import Foundation
import UIKit
import UnbluCoreSDK
import UnbluMobileCoBrowsingModule
import UnbluFirebaseNotificationModule
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate {
    static private(set) var instance: AppDelegate! = nil
    
    let serverUrl = ""
    let serverKey = ""
    var callModule: UnbluCallModuleApi?
    var unbluVisitor: UnbluVisitorClient?
    var mobileCoBrowsingModule: UnbluMobileCoBrowsingModuleApi?
    var userNotificationCenter = NotificationCenterDelegate()
    var coordinator: FirebaseDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.instance = self
        if  createClient() {
            // Uncomment the following line if you are using APNs
            // UIApplication.shared.registerForRemoteNotifications()
            
            // Comment out the following line if you are using APNs
            coordinator?.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
     
    // swizzling disabled (Info.plist FirebaseAppDelegateProxyEnabled: false)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Comment out the following line if you are using APNs
        Messaging.messaging().apnsToken = deviceToken;
        
        // Uncomment below if you are using APNs
        // let apnsToken = deviceToken.map { String(format: "%02x", $0 as CVarArg) }.joined()
        // UnbluNotificationApi.instance.deviceToken = apnsToken
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
            // Comment out the following line if you are using APNs
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
            print("unblu remote notification")
        } catch {
            print("not unblu remote notification")
            // if this not an unblu notification , call default implementation
            // Comment out the following line if you are using APNs
            coordinator?.on_application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
}


extension AppDelegate {
    
    func createClient() -> Bool {
        // Set Icon for CallKit UI
        UnbluClientConfiguration.callKitProviderIconResourceName = "go-to-app"

        //1. Register modules
        var config = createUnbluConfig()
        config.unbluPushNotificationVersion = .Encrypted  // replace with .EncryptedService if you want use the NotificationService class

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
         // Comment out the following line if you are using APNs
         coordinator = FirebaseDelegate()
       
        return true
    }
    
    func createUnbluConfig() -> UnbluClientConfiguration {  
        return UnbluClientConfiguration(unbluBaseUrl: serverUrl,
                                                     apiKey:  serverKey,
                                                     preferencesStorage: UserDefaultsPreferencesStorage(),
                                                     fileDownloadHandler: UnbluDefaultFileDownloadHandler(),
                                                     externalLinkHandler: UnbluDefaultExternalLinkHandler())        
    }
    
    func getUnbluView() -> UIView {
        return unbluVisitor?.view ?? UIView()
    }
    
    func startUnbluView(_ completion: @escaping ()->Void) {
        if unbluVisitor == nil {
           _ = createClient()
        }
        unbluVisitor?.isInitialized(success: { isInitialized in
            if !isInitialized {
                // Send APNs PushKit token and FCM token to the Unblu server
                self.unbluVisitor?.start { result in
                    switch result {
                    case .success:
                        completion()
                        print("Unblu started")
                    case .failure(let error):
                        print("Unblu failed with error: \(error)")
                    }
                }
            }
        })
    }
    
    func stopUnbluView(_ completion: @escaping ()->Void) {
        unbluVisitor?.isInitialized(success: { isInitialized in
            if isInitialized {
                self.unbluVisitor?.stop { result in
                    switch result {
                    case .success:
                        self.freeUnbluMemory()
                        completion()
                        print("Unblu stoppped")
                    case .failure(let error):
                        print("Unblu failed with error: \(error)")
                    }
                }
            }
        })
    }
    
    func freeUnbluMemory() {
        // assigning nil frees memory
        self.callModule = nil
        self.unbluVisitor  = nil
        self.mobileCoBrowsingModule = nil
    }
}

