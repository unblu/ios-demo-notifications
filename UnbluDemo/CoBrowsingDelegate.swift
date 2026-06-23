//
//  CoBrowsingDelegate.swift
//

import Foundation
import UnbluMobileCoBrowsingModule



class CoBrowsingDelegate: UnbluMobileCoBrowsingModuleDelegate {
    
    func unbluMobileCoBrowsingModuleDidStartCoBrowsing(_ unbluMobileCoBrowsingModuleApi: UnbluMobileCoBrowsingModuleApi) {
        print("CoBrowsingDelegate: co-browsing started")
    }

    func unbluMobileCoBrowsingModuleDidStopCoBrowsing(_ unbluMobileCoBrowsingModuleApi: UnbluMobileCoBrowsingModuleApi) {
        print("CoBrowsingDelegate: co-browsing stopped")
    }
}
