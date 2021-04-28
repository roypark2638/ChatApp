//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addSubviews()
        addButtonActions()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let imageSize = view.width/3
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.top,
            width: imageSize,
            height: imageSize
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: imageView.bottom + 10,
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
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(signInButton)
        scrollView.addSubview(signUpButton)
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
        Auth.auth().signIn(
            withEmail: email,
            password: password) { result, error in
            guard let result = result, error == nil else {
                print("Error signing in")
                return
            }
            
            let user = result.user
        }
    }
    
    @objc private func didTapSignUp() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
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
