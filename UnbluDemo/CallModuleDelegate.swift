//
//  CallModuleDelegate.swift
//

import Foundation
import UnbluCoreSDK

class CallModuleDelegate: UnbluCallModuleDelegate {
    // Called when the Picture-in-Picture button is tapped; let the SDK handle it.
    func unbluMobileCallModuleHandlePiPButtonClick(_ unbluCallModuleApi: any UnbluCoreSDK.UnbluCallModuleApi) -> UnbluCoreSDK.ButtonInterceptorAction {
        print("CallModuleDelegate: PiP button clicked")
        return .useInternalHandler
    }


    func unbluCallModuleDidStartCall(_ unbluCallModuleApi: UnbluCallModuleApi) {
        print("CallModuleDelegate: call started")
    }
    func unbluCallModuleDidEndCall(_ unbluCallModuleApi: UnbluCallModuleApi) {
        print("CallModuleDelegate: call ended")
    }
}
