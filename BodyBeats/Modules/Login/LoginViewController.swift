//
//  LoginViewController.swift
//  BodyBeats
//
//  Created by Thaaranya Subramani on 01/02/24.
//

import UIKit
import AuthenticationServices
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imageloginBg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnApple: ASAuthorizationAppleIDButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func btnAppleClicked(_ sender: UIButton) {
        // Check Credential State
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                print("The Apple ID credential is valid.")
                break
            case .revoked:
                self.appleAccountLoginHandling(message: "The Apple ID credential is revoked.")
                print("The Apple ID credential is revoked.")
                break
            case .notFound:
                self.appleAccountLoginHandling(message: "Need to handle apple SignIn request")
                self.handleAppleIdRequest()
                break
            default:
                self.appleAccountLoginHandling(message: "Issue on sign in with Apple Accout")
                print(String(describing: error?.localizedDescription))
                break
            }
        }
    }
    
    func appleAccountLoginHandling(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Apple SignIn", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                print("OK button tapped")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Ganaral Method
extension LoginViewController {
    
    func setUI() {
        // set button Animation
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: imageloginBg.frame.width, height: imageloginBg.frame.height)
        
        imageloginBg.addSubview(tintView)
        txtUserName.layer.borderWidth = 1
        txtUserName.layer.borderColor = UIColor.white.cgColor
        txtUserName.layer.cornerRadius = 5
        txtUserName.paddingLeftCustom = 8
        
        txtUserName.layer.masksToBounds = true
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.cornerRadius = 5
        txtPassword.paddingLeftCustom = 8
        
        txtPassword.layer.masksToBounds = true
        btnApple.layer.cornerRadius = 5
        btnSignIn.layer.cornerRadius = 5
        
        
        btnApple.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        startAnimatingPressActions()
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
            self?.btnApple.transform = .identity
        },
                       completion: nil)
    }
    
    // Existing Account Setup Flow
    @objc func handleAppleIdRequest() {
        
        let appleSignInRequest = ASAuthorizationAppleIDProvider().createRequest()
        // set scope
        appleSignInRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [appleSignInRequest])
        // set delegate
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - Button Action
extension LoginViewController {
    
    @IBAction func btnSignInClick(_ sender: Any) {
        if isValidate() {
            let swiftUIView =  ActiveTabView().environmentObject(HealthManager())
            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.modalPresentationStyle = .fullScreen
            hostingController.modalTransitionStyle = .crossDissolve
            self.present(hostingController, animated: true, completion: nil)
        }
    }
}

// MARK: - Validation
extension LoginViewController {
    private func isValidate() -> Bool {
        
        if txtUserName.text!.isEmpty {
            self.alert(message: "Enter username", title: "Alert")
            return false
        } else if txtPassword.text!.isEmpty {
            self.alert(message: "Enter password", title: "Alert")
            return false
        }
        return true
    }
}

// MARK: - Delegate Methods
extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    // ASAuthorizationController Presentation Context Providing
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    // Handle ASAuthorizationController Delegate and Presentation Context
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let _ = appleIDCredentials.user
        let _ = appleIDCredentials.fullName
        let _ = appleIDCredentials.email
        userID = appleIDCredentials.user
        
        // first time get User Id, User Name, real user status, Identity Token and email when show email
        print("User Id - \(appleIDCredentials.user)")
        print("User Name - \(appleIDCredentials.fullName?.description ?? "N/A")")
        print("User Email - \(appleIDCredentials.email ?? "N/A")")
        print("Real User Status - \(appleIDCredentials.realUserStatus.rawValue)")
        
        if let identityTokenData = appleIDCredentials.identityToken,
           let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
            print("Identity Token \(identityTokenString)")
        }
        if appleIDCredentials.user.count > 0 {
            let homeView = ActiveTabView().environmentObject(HealthManager())
            let hostingController = UIHostingController(rootView: homeView)
            hostingController.modalPresentationStyle = .fullScreen
            self.present(hostingController, animated: true, completion: nil)
        }
        //        if appleIDCredentials.user.count > 0 {
        //            if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
        //                if ((appleIDCredentials.fullName?.givenName) != nil) {
        //                    homeVC.userName = ("\(appleIDCredentials.fullName?.givenName ?? "N/A")")
        //                } else {
        //                    homeVC.userName = "\(appleIDCredentials.user)"
        //                }
        //
        //                self.navigationController?.pushViewController(homeVC, animated: true)
        //            }
        //        }
    }
    
    // Handle ASAuthorizationController Delegate and Presentation Context
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Animation
extension LoginViewController {
    
    func startAnimatingPressActions() {
        btnApple.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        btnApple.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
            button.transform = transform
        }, completion: nil)
    }
}

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
