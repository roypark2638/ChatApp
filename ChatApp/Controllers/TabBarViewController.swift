//
//  TabBarViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/29/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }

    private func createTabBar() {
        
        let chatVC = ConversationsViewController()
        let profileVC = ProfileViewController()
        
        let chatNav = UINavigationController(rootViewController: chatVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        if #available(iOS 14.0, *) {
            chatVC.navigationItem.backButtonDisplayMode = .minimal
            profileNav.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            chatVC.navigationItem.backButtonTitle = ""
            profileNav.navigationItem.backButtonTitle = ""
        }
        
        chatNav.navigationBar.prefersLargeTitles = true
        
        profileNav.navigationBar.prefersLargeTitles = true
        
        chatNav.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message.circle.fill"), tag: 1)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        
        self.setViewControllers([chatNav, profileNav], animated: false)
    }

}
