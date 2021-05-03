//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class SignInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let emailField = AuthTextField(type: .email, title: nil)
    
    private let passwordField = AuthTextField(type: .password, title: nil)
    
    private let signInButton = AuthButton(type: .signIn, title: nil)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    private let googleLoginButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loginObserver = NotificationCenter.default.addObserver(
            forName: .didLogInNotification,
            object: nil,
            queue: .main) { [weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        configureNavigationBar()
        addSubviews()
        addButtonActions()
        
        emailField.delegate = self
        passwordField.delegate = self
        facebookLoginButton.delegate = self
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let imageSize = view.width/3
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.top-40,
            width: imageSize,
            height: imageSize
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: imageView.bottom,
            width: view.width - 40,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 16,
            width: view.width-40,
            height: 50
        )
        
        signInButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 46,
            width: view.width-40,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 20,
            y: signInButton.bottom + 16,
            width: view.width-40,
            height: 50
        )
        
        facebookLoginButton.frame = CGRect(
            x: 20,
            y: signUpButton.bottom + 30,
            width: view.width-40,
            height: 50
        )
        
        googleLoginButton.frame = CGRect(
            x: 20,
            y: facebookLoginButton.bottom + 16,
            width: view.width-40,
            height: 50
        )
        
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(signInButton)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(loginObserver)
        }
    }

    private func configureNavigationBar() {

        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true

    }

    private func addButtonActions() {
        signInButton.addTarget(
            self,
            action: #selector(didTapSignIn),
            for: .touchUpInside
        )
        
        signUpButton.addTarget(
            self,
            action: #selector(didTapSignUp),
            for: .touchUpInside
        )
    }
    
    private func showAlertUserLoginError() {
        let alert = UIAlertController(
            title: "Ooops",
            message: "Please check your input again.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Objc
    
    @objc private func didTapSignIn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            showAlertUserLoginError()
            return
        }
        
        // Firebase sign in
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                print("\nError with Signing in \(error.localizedDescription)")
                
            case .success(let user):
                print("successfully logged in with the \(user)\n")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    @objc private func didTapSignUp() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapSignIn()
        }
        return true
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with Facebook")
            return
        }
        
        let facebookRequest = FBSDKCoreKit.GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, name"],
            tokenString: token,
            version: nil,
            httpMethod: .get
        )
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any],
                  error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            
            guard let username = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to get email and username from FB result")
                return
            }
            let nameComponents = username.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.canCreateNewUser(with: email) { result in
                switch result {
                case .success:
                    DatabaseManager.shared.insertUser(
                        with: ChatAppUser(
                            firstName: firstName,
                            lastName: lastName,
                            email: email)) { result in
                        switch result {
                        case .success:
                            print("\(result )")
                            let credential = FacebookAuthProvider.credential(withAccessToken: token)
                            
                            AuthManager.shared.signIn(with: credential) { [weak self] result in
                                switch result {
                                case .failure(let error):
                                    print("Error with signing in with Facebook Credential \(error.localizedDescription)")
                                case .success:
                                    print("Successfully signed in with Facebook Credential")
                                    self?.dismiss(animated: true, completion: nil)
                                    let vc = TabBarViewController()
                                    vc.modalPresentationStyle = .fullScreen
                                    self?.present(vc, animated: true, completion: nil)
                                    
                                }
                            }
                        case .failure(let error):
                            print("error inserting user from signinVC with FB\(error)")
                        }
                    }
                case .failure(let error):
                    print("failed to create new user \(error)")
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}

// MARK: - GIDSignInDelegate

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("failed to sign in with Google: \(error.localizedDescription)")
            }
            return
        }
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName
              else {
            print("google one of the user info doesn't exist")
            return
        }
        
        print("Did sign in with Google: \(String(describing: user))")
        
        DatabaseManager.shared.canCreateNewUser(with: email) { result in
            switch result {
            case .success:
                DatabaseManager.shared.insertUser(
                    with:
                        ChatAppUser(
                            firstName: firstName,
                            lastName: lastName,
                            email: email)) { result in
                    switch result {
                    
                    case .success:
                        guard let authentication = user.authentication else {
                            print("Missing auth object off of google user")
                            return
                        }
                        let credential = GoogleAuthProvider.credential(
                            withIDToken: authentication.idToken,
                            accessToken: authentication.accessToken
                        )
                        
                        AuthManager.shared.signIn(
                            with: credential) { [weak self] result in
                            switch result {
                            case .success:
                                print("\nsign in with Google credential successfully")
                                let vc = TabBarViewController()
                                vc.modalPresentationStyle = .fullScreen
                                self?.present(vc, animated: true)
                            
                            case .failure(let error):
                                print("\nfailed to sign in with Google credential error: \(error)")
                            }
                        }
                    case .failure(let error):
                        print("seems like the same email exists \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("seems like the same email exists \(error.localizedDescription)")
            }
        }
        


    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user got disconnected")
    }
}
