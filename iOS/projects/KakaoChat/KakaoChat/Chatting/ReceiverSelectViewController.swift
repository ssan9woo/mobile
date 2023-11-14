//
//  ReceiverSelectViewController.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/08.
//

import UIKit

class ReceiverSelectViewController: UITableViewController {

    private let cellID = "cellID"
    var chatLogVC: ChatLogViewController?
    let sectionView: UIView = {
        let view = UIView()
        let title = UILabel()
        view.addSubview(title)
        
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.clipsToBounds = true
        title.text = "친구"
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        let user = FirebaseAuthManager.shared.indexOfUserInUsers(index: indexPath.row)
        cell.updateCell(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseAuthManager.shared.numberOfUsers
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = FirebaseAuthManager.shared.indexOfUserInUsers(index: indexPath.row)
            self.chatLogVC?.showChatVC(user: user)
        }
    }
}
