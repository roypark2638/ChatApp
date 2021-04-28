//
//  AuthTextField.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit

class AuthTextField: UITextField {
    
    enum textFieldType {
        case email
        case password
        case plain
        
        var title: String {
            switch self {
            case .email:
                return "Email Address"
            case .password:
                return "Password"
            case .plain:
                return "-"
            }
        }
    }
    
    let type: textFieldType

    init(type: textFieldType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        placeholder = type.title
        if title != nil {
            placeholder = title
        }
        
        configureField()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureField() {
        backgroundColor = .secondarySystemBackground
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .continue
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        leftViewMode = .always
        leftView = UIView(frame: CGRect(
                            x: 0,
                            y: 0,
                            width: 16,
                            height: 0))
        if type == .email {
            textContentType = .emailAddress
            keyboardType = .emailAddress
        }
        else if type == .password {
            returnKeyType = .done
            isSecureTextEntry = true
        }
    }
}
