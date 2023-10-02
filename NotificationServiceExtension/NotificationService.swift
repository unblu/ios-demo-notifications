//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Denis Mikaya on 02.10.2023.
//
import UserNotifications
import UnbluCoreSDK
import os.log

/**
 * This is a notification service extension that runs separately from the main application.
 * This class uses a key shared with the application to decrypt notifications.
*/
class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        os_log("%{public}@", log: OSLog(subsystem: "UnbluNotificationService", category: "Encrytpted notifications"), type: OSLogType.debug, "Notification received!")
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            if  let dictonary = decryptBody(userInfo: bestAttemptContent.userInfo)
            {
                guard let body =  dictonary["text"] as? String else {
                    contentHandler(bestAttemptContent)
                    return
                }
                guard let title = dictonary["title"] as? String  else {
                    contentHandler(bestAttemptContent)
                    return
                }
                bestAttemptContent.userInfo = dictonary as [AnyHashable : Any]
                //FIXME: added a signature, to see that it is transmitted through the extension, remove it
                bestAttemptContent.body = body + " [via NotificationService] "

                bestAttemptContent.title = title
                bestAttemptContent.sound = .default

            } else {
                bestAttemptContent.body = ""
                bestAttemptContent.title = ""
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    func decryptBody(userInfo: [AnyHashable : Any]) -> [String : Any?]? {
        if let encryptedData = userInfo[UnbluEncryptedNotificationServiceHelper.KEY_ENCRYPTED_DATA] {
            guard let dictonary = UnbluEncryptedNotificationServiceHelper.decode(encryptedData as! String)  else {
                return nil
            }
            return dictonary
        }
        return nil
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    


}
