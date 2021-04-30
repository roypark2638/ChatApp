//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Roy Park on 4/27/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
        return tableView
    }()
    
    let data = ["Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile "
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBackground
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {

        let actionSheet = UIAlertController(
            title: "Do you want to Log Out?",
            message: "",
            preferredStyle: .actionSheet)
        
            actionSheet.addAction(
            UIAlertAction(
                title: "Log Out",
                style: .destructive,
                handler: { [weak self] _ in
                AuthManager.shared.signOut()
                
                let vc = SignInViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
                
                
                }))
            
            actionSheet.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil))
            
            self.present(actionSheet, animated: true)
        }
        
    }
}
