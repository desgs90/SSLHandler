//
//  SSLValidationHandler.swift
//  Diego
//
//  Created by Diego Diego on 3/8/18.
//

import Foundation
import UIKit

class SSLValidationHandler: NSObject {
    
    private static var sharedService: SSLValidationHandler = {
        let service = SSLValidationHandler()
        return service
    }()
    
    @objc class func shared() -> SSLValidationHandler {
        return sharedService
    }
    
    
    var sessionManager = SessionManager()
    let customSessionDelegate = SessionDelegate()
    @objc func isValidCertificate(_ url:URLRequest, callback: @escaping (Bool) -> Void ) {
        
       
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "URL.com": .pinCertificates(
//                certificates: ServerTrustPolicy.certificates(),
//                validateCertificateChain: true,
//                validateHost: true
//            )
//        ]
//        sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral,
//                                             delegate: customSessionDelegate,
//                                             serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//        )
//        sessionManager.request("https://URL.com").response { response in
//            self.showResult(success: response.response != nil)
//            //callback(response.response != nil)
//            callback(false)
//        }
        
        
        sessionManager = SessionManager(
            delegate: customSessionDelegate, // Feeding our own session delegate
            serverTrustPolicyManager: CustomServerTrustPolicyManager(
                policies: [:]
            )
        )
        sessionManager.request("https://URL.com").response { response in
            self.showResult(success: response.response != nil)
            //callback(response.response != nil)
            callback(false)
        }
    }
    
    
    ////
    fileprivate func showResult(success: Bool) {
        if success {
            print("🚀 Success")
        } else {
            print("🚫 Request failed")
        }
    }
    
    static func pinnedCertificates() -> [Data] {
        var certificates: [Data] = []
        
        if let pinnedCertificateURL = Bundle.main.url(forResource: "CERNAME", withExtension: "der") {
            do {
                let pinnedCertificateData = try Data(contentsOf: pinnedCertificateURL)
                certificates.append(pinnedCertificateData)
            } catch (_) {
                // Handle error
            }
        }
        
        return certificates
    }
}
