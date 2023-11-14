//
//  ChatViewController.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/08.
//

import UIKit
import Firebase

class ChattingRoomViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var messages: [Message] = []
    
    var to: User? {
        didSet {
            navigationItem.title = to?.name
            observeMessages()
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userMessagesRef = Firebase.Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { snapshot in
            let messageId = snapshot.key
            let messagesRef = Firebase.Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { snapshot in
                
                if let dictionary = snapshot.value as? [String:Any], let fromId = dictionary["fromId"] as? String, let text = dictionary["text"] as? String, let timestamp = dictionary["timeStamp"] as? Int, let toId = dictionary["toId"] as? String {
                    let message = Message(fromId: fromId, text: text, timeStamp: timestamp, toId: toId)
                    
                    if message.partnerId() == self.to?.id {
                        self.messages.append(message)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }, withCancel: nil)

        }, withCancel: nil)
    }
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.addLeftPadding()
        tf.placeholder = "Write Message..."
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 14
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = messages[indexPath.item].text
        height = estimateFrameForText(text: text).height + 20
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }
        let message = messages[indexPath.item]
        setupCell(cell: cell, message: message)
        cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.to?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        cell.textView.text = message.text
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true

            cell.bubbleViewLeadingAnchor?.isActive = false
            cell.bubbleViewTrailingAnchor?.isActive = true
        } else {
            cell.bubbleView.backgroundColor = ChatMessageCell.grayColor
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewTrailingAnchor?.isActive = false
            cell.bubbleViewLeadingAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func setView() {
        // cell 이 아니라 collectionview 자체의 inset 을 정하는것.
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 70, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        inputTF.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.backgroundColor = .systemGray6
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        inputTF.translatesAutoresizingMaskIntoConstraints = false
        inputTF.backgroundColor = .systemGray4
        inputTF.layer.masksToBounds = true
        inputTF.layer.cornerRadius = 14
        containerView.addSubview(inputTF)
        
        let constraint = [
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            inputTF.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            inputTF.heightAnchor.constraint(equalToConstant: 40),
            inputTF.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            inputTF.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    func handleSend() {
        let ref = Firebase.Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        if let text = inputTF.text, let toUser = to, let toId = toUser.id, let fromId = Auth.auth().currentUser?.uid {
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values = ["text":text, "fromId":fromId, "toId": toId, "timeStamp":timeStamp] as [String : Any]
                        
            childRef.updateChildValues(values) { error, ref in
                guard error == nil, let messageId = childRef.key else { return }
                self.inputTF.text = nil
                
                let userMessagesRef = Firebase.Database.database().reference().child("user-messages").child(fromId)
                userMessagesRef.updateChildValues([messageId:1])
                
                let recipientRef = Firebase.Database.database().reference().child("user-messages").child(toId)
                recipientRef.updateChildValues([messageId:1])
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
