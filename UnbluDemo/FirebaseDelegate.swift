//
//  FirebaseDelegate.swift
//

import Foundation

import UnbluFirebaseNotificationModule


class FirebaseDelegate: UnbluFirebaseUIApplicationDelegate {
   
    override func on_application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("not unblu remote notification")
    }

   
    override func on_application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("not unblu remote notification")
    }
}
