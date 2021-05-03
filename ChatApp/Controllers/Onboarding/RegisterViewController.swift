//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Profile")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlusButton"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let emailField = AuthTextField(type: .email, title: nil)
    
    private let firstNameField = AuthTextField(type: .plain, title: "First Name")
    
    private let lastNameField = AuthTextField(type: .plain, title: "Last Name")
    
    private let passwordField = AuthTextField(type: .password, title: nil)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addSubviews()
        addButtonActions()
        emailField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let imageSize = view.width/3.5
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.top + 20,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageSize/2
        imageView.layer.zPosition = -1
        
        let buttonSize: CGFloat = 30
        plusButton.frame = CGRect(
            x: imageView.right - buttonSize + 4,
            y: imageView.bottom - buttonSize + 4,
            width: buttonSize,
            height: buttonSize
        )
        
        firstNameField.frame = CGRect(
            x: 20,
            y: imageView.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        lastNameField.frame = CGRect(
            x: 20,
            y: firstNameField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: lastNameField.bottom + 10,
            width: view.width - 40,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 10,
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
    
    // MARK: - Methods
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(plusButton)
    }
    

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func addButtonActions() {
        signUpButton.addTarget(
            self,
            action: #selector(didTapSignUp),
            for: .touchUpInside
        )
        
        plusButton.addTarget(
            self,
            action: #selector(didTapImageView),
            for: .touchUpInside
        )
    }
    
    private func showAlertUserSignUpError(message: String = "Please check all of information to create new account.") {
        let alert = UIAlertController(
            title: "Ooops",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: .cancel,
                            handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapImageView() {
        print("Image tapped")
        let actionSheets = UIAlertController(
            title: "Profile Picture", message: "How do you want to pick your picture?", preferredStyle: .actionSheet)
        actionSheets.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        actionSheets.addAction(UIAlertAction(
                                title: "Choose From Photo Library",
                                style: .default,
                                handler: { [weak self] _ in
                                    DispatchQueue.main.async {
                                        self?.presentPhotoPicker()
                                    }
                                }))
        actionSheets.addAction(UIAlertAction(
                                title: "Take a Photo",
                                style: .default,
                                handler: { [weak self] _ in
                                    DispatchQueue.main.async {
                                        self?.presentCamera()
                                    }
                                }))
        
        present(actionSheets, animated: true, completion: nil)
    }
    
    private func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    private func validateUserInputFields() -> (String, String, String, String)? {
        if let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let firstName = firstNameField.text,
              !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              firstName.count >= 2,
              let lastName = lastNameField.text,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty,
              lastName.count >= 2,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 {
            return (email, firstName, lastName, password)
        }
        else {
            showAlertUserSignUpError()
            return nil
        }
    }
    
    private func resignTextFields() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc private func didTapSignUp() {
        resignTextFields()
        guard let (email, firstName, lastName, password) = validateUserInputFields() else {
            return
        }
        
        // Firebase register and log in
        spinner.show(in: scrollView)
        
        AuthManager.shared.signUp(
            with: firstName,
            lastName: lastName,
            email: email,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.spinner.dismiss()
                
                switch result {
                case .success:
                    print("\n successfully created user!!!!\n\n")
                    strongSelf.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print("Error creating user: \n\(error.localizedDescription)")
                    strongSelf.showAlertUserSignUpError(message: "Seems like this email address is already exist. Please try with different email address")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
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

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return
        }
        imageView.image = image
    }
}
