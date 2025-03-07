//
//  SocialLoginManager.swift
//  Tradesman Tech
//
//  Created by YATIN  KALRA on 12/02/25.
//


import UIKit
import GoogleSignIn
import AuthenticationServices

class SocialLoginManager: NSObject {

    static let shared = SocialLoginManager()
    private override init() {}
    private var appleSignInCompletion: ((Result<ASAuthorizationAppleIDCredential, Never>) -> Void)?
 let clientID = "Your google client ID"
    // MARK: - Google Sign-In
    func handleGoogleSignIn(presentingViewController: UIViewController, completion: @escaping (Result<GIDSignInResult, Never>) -> Void) {
        
        
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            guard error == nil else {
                if let error = error {
                    print(error,"google sign in error")
                    ///completion(.failure(error))
                }
                return
            }
            if let user = user {
                completion(.success(user))
                GIDSignIn.sharedInstance.signOut()
            }
            // If sign in succeeded, display the app's main content View.
        }
        
    }

    // MARK: - Apple Sign-In
    func handleAppleSignIn(completion: @escaping (Result<ASAuthorizationAppleIDCredential, Never>) -> Void) {
        self.appleSignInCompletion = completion
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
      
    }
}

extension SocialLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Pass the successful result back to the completion handler
                appleSignInCompletion?(.success(appleIDCredential))
            }
            // Reset the completion handler after use
            appleSignInCompletion = nil
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Pass the error back to the completion handler
           print(error,"apple sign in error")
            // Reset the completion handler after use
            appleSignInCompletion = nil
        }
}
