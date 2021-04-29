//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
        
    }
    
    private func validateAuth() {
        if !AuthManager.shared.isSignedIn() {
            print("\n\nuser is currently signed in")
            let vc = SignInViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
        else {
            print("\n\nuser is currently NOT signed in")
        }
        
    }

}

