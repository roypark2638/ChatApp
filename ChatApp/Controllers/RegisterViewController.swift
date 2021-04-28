//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit

class RegisterViewController: UIViewController {

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
    
    private let usernameField = AuthTextField(type: .email, title: "username")
    
    private let passwordField = AuthTextField(type: .password, title: nil)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addSubviews()
        addButtonActions()
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let imageSize = view.width/3
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top,
            width: imageSize,
            height: imageSize
        )
        
        usernameField.frame = CGRect(
            x: 20,
            y: imageView.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: usernameField.bottom + 16,
            width: view.width - 40,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 16,
            width: view.width-40,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 46,
            width: view.width-40,
            height: 50
        )
        

    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(signUpButton)
    }
    

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
    }

    private func addButtonActions() {
        signUpButton.addTarget(
            self,
            action: #selector(didTapSignUp),
            for: .touchUpInside
        )
    }
    
    private func showAlertUserSignUpError() {
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
    
    @objc private func didTapSignIn() {
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let username = usernameField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              username.count >= 2,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            showAlertUserSignUpError()
            return
        }
    }
    
    @objc private func didTapSignUp() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapSignUp()
        }
        return true
    }
}
