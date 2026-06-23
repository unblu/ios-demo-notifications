//
//  VisitorClientDelegate.swift
//

import Foundation
import UnbluCoreSDK


class VisitorClientDelegate: UnbluVisitorClientDelegate {
    func unblu(updatedConversationInfos conversationInfos: [UnbluCoreSDK.ConversationInfo]) {
        print("VisitorClientDelegate: updated conversation infos (count: \(conversationInfos.count))")
    }

    func didHideModalUi() {
        print("VisitorClientDelegate: did hide modal UI")
    }

    // Return the action for taps on the active-conversation button; defer to the SDK.
    func handleActiveConversationButtonClick() -> UnbluCoreSDK.ButtonInterceptorAction {
        print("VisitorClientDelegate: active conversation button clicked")
        return .useInternalHandler
    }

    // Return the action when the Unblu UI is collapsed; defer to the SDK.
    func handleUnbluCollapsed() -> UnbluCoreSDK.ButtonInterceptorAction {
        print("VisitorClientDelegate: Unblu collapsed")
        return .useInternalHandler
    }

    func unblu(didUpdatePersonActivityInfo personActivity: PersonActivityInfo) {
        print("VisitorClientDelegate: did update person activity info")
    }

    func unbluDidInitialize() {
        print("VisitorClientDelegate: did initialize")
    }

    func unbluDidDeinitialize() {
        print("VisitorClientDelegate: did deinitialize")
    }

    func unblu(didUpdateAgentAvailability isAvailable: Bool) {
        print("VisitorClientDelegate: agent availability changed (isAvailable: \(isAvailable))")
    }

    func unblu(didUpdatePersonInfo personInfo: PersonInfo) {
        print("VisitorClientDelegate: did update person info")
    }

    func unblu(didUpdateUnreadMessages count: Int) {
        print("VisitorClientDelegate: unread messages changed (count: \(count))")
    }

    func unblu(didChangeOpenConversation openConversation: UnbluConversation?) {
        print("VisitorClientDelegate: open conversation changed (hasConversation: \(openConversation != nil))")
    }

    func unblu(didRequestHideUi reason: UnbluUiHideRequestReason, conversationId: String?) {
        print("VisitorClientDelegate: did request hide UI (reason: \(reason), conversationId: \(conversationId ?? "nil"))")
    }

    func unblu(didToggleCallUi isOpen: Bool) {
        print("VisitorClientDelegate: call UI toggled (isOpen: \(isOpen))")
    }

    func unblu(didRequestShowUi withReason: UnbluUiRequestReason, requestedByUser: Bool) {
        print("VisitorClientDelegate: did request show UI (reason: \(withReason), requestedByUser: \(requestedByUser))")
    }

    func unblu(didReceiveError type: UnbluClientErrorType, description: String) {
        print("VisitorClientDelegate: did receive error (type: \(type), description: \(description))")
    }
}
