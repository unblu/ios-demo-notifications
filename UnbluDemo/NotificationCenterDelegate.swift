//
//  NotificationCenterDelegate.swift
//

import Foundation
import UnbluCoreSDK


 class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    

    // process the response (tap on it) to a notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        do {
            try UnbluNotificationApi.instance.didReceive(notificationResponse: response, withCompletionHandler: completionHandler)
            print("NotificationCenterDelegate: handled unblu notification response")
        } catch {
            print("NotificationCenterDelegate: not an unblu notification response")
            completionHandler()
        }
    }
    
     // the app is running in the foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        do {
            try UnbluNotificationApi.instance.willPresent(notification: notification, withCompletionHandler: completionHandler)
            print("NotificationCenterDelegate: presenting unblu notification in foreground")
        } catch {
            print("NotificationCenterDelegate: not an unblu notification to present")
            completionHandler([.alert, .badge, .sound])
        }
    }
}
