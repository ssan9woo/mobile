//
//  ChattingViewController.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/04.
//

import UIKit
import Firebase

class ChatLogViewController: UITableViewController {

    private let cellId = "cellId"
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellId)
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        observeMessages()
    }
    
    func observeMessages() {
        FirebaseAuthManager.shared.clearMessages()
        self.tableView.reloadData()
        FirebaseAuthManager.shared.observeMessages {
            // 여러번의 reload 를 timer 를 사용하여 줄임
            // 반복 할 동안 새로운 타이머가 계속 생성됨.
            // 시간을 더 늘려주면 앞에있던 타이머가 실행되기 전에 새로운 타이머가 생성되므로, 앞에있던 스케줄이 사라짐
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        }
    }
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setNavigationBar() {
        let label = UILabel()
        label.text = "chat"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        let leftItem = UIBarButtonItem(customView: label)
        navigationItem.leftBarButtonItem = leftItem
        navigationController?.navigationBar.barTintColor = .white
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(selectUserToSend), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func selectUserToSend() {
        let receiverSelectVC = ReceiverSelectViewController()
        receiverSelectVC.chatLogVC = self
        present(receiverSelectVC, animated: true, completion: nil)
    }
    
    func showChatVC(user: User) {
        let chatVC = ChattingRoomViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.to = user
        chatVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseAuthManager.shared.numberOfMessages
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        let message = FirebaseAuthManager.shared.indexOfMessageInMessages(index: indexPath.row)
        
        FirebaseAuthManager.shared.observeUser(uid: message.partnerId()) { user in
            let date = Date(timeIntervalSince1970: Double(message.timeStamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from: date)
            
            cell.nameLabel.text = user.name
            cell.subTitleLabel.text = message.text
            cell.timeStampLabel.text = dateString
            if let profileUrl = user.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = FirebaseAuthManager.shared.indexOfMessageInMessages(index: indexPath.row)
        
        let ref = Firebase.Database.database().reference().child("users").child(message.partnerId())
        ref.observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String:Any], let name = dictionary["name"] as? String, let email = dictionary["email"] as? String, let profileImageUrl = dictionary["profileImageUrl"] as? String {
                var user = User(name: name, email: email, profileImageUrl: profileImageUrl)
                user.id = message.partnerId()
                self.showChatVC(user: user)
            }
        }
    }
}

