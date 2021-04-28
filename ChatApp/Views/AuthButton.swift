//
//  AuthButton.swift
//  ChatApp
//
//  Created by Roy Park on 4/28/21.
//

import UIKit

class AuthButton: UIButton {
    
    enum AuthButtonType {
        case signUp
        case signIn
        case plain
        
        var title: String {
            switch self {
            case .signUp:
                return "Sign Up"
            case .signIn:
                return "Sign In"
            case .plain:
                return "-"
            }
        }
    }
    
    private let type: AuthButtonType

    init(type: AuthButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.title, for: .normal)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureButton() {
        titleLabel?.numberOfLines = 1
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        if type == .signUp {
            backgroundColor = UIColor(rgb: 0x546E7A)
            setTitleColor(.systemBackground, for: .normal)
        }
        else if type == .signIn {
            backgroundColor = UIColor(rgb: 0xA4EBF3)
            setTitleColor(.systemBackground, for: .normal)
        }
    }
}
