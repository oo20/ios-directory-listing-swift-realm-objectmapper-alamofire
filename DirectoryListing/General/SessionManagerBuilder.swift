//
//  SessionManagerBuilder.swift
//  DirectoryListing
//
//  Created by Michael Steele on 8/4/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import Alamofire

class SessionManagerBuilder {
    
    static func sessionManagerAllowOnlyValidCerts() -> Alamofire.SessionManager {
        return Alamofire.SessionManager()
    }
    
    static func sessionManagerAllowInvalidCerts() -> Alamofire.SessionManager {
        
        let manager: Alamofire.SessionManager = {
            
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                AppManager.serverURL: .disableEvaluation
            ]
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(
                configuration: URLSessionConfiguration.default,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )
            
            let sessionManager = SessionManager(
                serverTrustPolicyManager: ServerTrustPolicyManager(
                    policies: [AppManager.serverURL: .disableEvaluation]
                )
            )
            
            manager.delegate.sessionDidReceiveChallenge = { session, challenge in
                var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
                var credential: URLCredential?
                
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, let trust = challenge.protectionSpace.serverTrust {
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                    credential = URLCredential(trust: trust)
                } else {
                    if challenge.previousFailureCount > 0 {
                        disposition = .cancelAuthenticationChallenge
                    } else {
                        credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                        
                        if credential != nil {
                            disposition = .useCredential
                        }
                    }
                }
                
                return (disposition, credential)
            }
            
            return manager
        }()
        
        return manager;
        
    }
}
