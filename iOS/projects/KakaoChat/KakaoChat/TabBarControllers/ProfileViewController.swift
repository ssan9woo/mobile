//
//  ViewController.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/02.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {
    
    private let cellID = "ProfileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        setProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            FirebaseAuthManager.shared.fetchUsers {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }
    }

    func setProfileView() {
        // main view
        view.backgroundColor = .systemBackground
        
        // tableview
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellID)
        
        // navigation
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            return
        }
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

extension ProfileViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        if indexPath.section == 1 {
            let user = FirebaseAuthManager.shared.indexOfUserInUsers(index: indexPath.row)
            cell.updateCell(user: user)
        } else {
            if let myProfile = FirebaseAuthManager.shared.getMyProfile() {
                cell.updateCell(user: myProfile)
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : FirebaseAuthManager.shared.numberOfUsers
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let label = UILabel()
        sectionView.addSubview(label)
        
        label.text = section == 0 ? "내 프로필" : "친구"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

