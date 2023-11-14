//
//  Manager.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/13.
//

import Foundation
import Firebase

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    
    private var myProfile: User?
    private var users: [User] = []
    private var messages: [Message] = []
    private var messageDict: [String:Message] = [:]

    func clearMessages() {
        self.messages.removeAll()
        self.messageDict.removeAll()
    }
    
    var numberOfUsers: Int {
        return users.count
    }
    
    var numberOfMessages: Int {
        return messages.count
    }
    
    func indexOfUserInUsers(index: Int) -> User {
        return users[index]
    }
    
    func indexOfMessageInMessages(index: Int) -> Message {
        return messages[index]
    }
    
    func getMyProfile() -> User? {
        guard let myProfile = myProfile else { return nil }
        return myProfile
    }
    
    func observeUser(uid: String, completionHandler: @escaping (User) -> Void) {
        let ref = Firebase.Database.database().reference().child("users").child(uid)
        ref.observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String:Any], let name = dictionary["name"] as? String, let profileImageUrl = dictionary["profileImageUrl"] as? String, let email = dictionary["email"] as? String {
                
                let user = User(name: name, email: email, profileImageUrl: profileImageUrl)
                completionHandler(user)
            }
        }, withCancel: nil)
    }
    
    func observeMessages(completionHandler: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firebase.Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messagesRef = Firebase.Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value) { snapshot in
                if let dictionrary = snapshot.value as? [String:Any], let fromId = dictionrary["fromId"] as? String, let toId = dictionrary["toId"] as? String, let timeStamp = dictionrary["timeStamp"] as? Int, let text = dictionrary["text"] as? String {

                    let message = Message(fromId: fromId, text: text, timeStamp: timeStamp, toId: toId)
                    let chatPartnerId = message.partnerId()
                    
                    self.messageDict[chatPartnerId] = message
                    self.messages = Array(self.messageDict.values)
                    self.messages = self.messages.sorted { $0.timeStamp > $1.timeStamp }
                }
                completionHandler()
            }
        }
    }
    
    func fetchUsers(completionHandler: @escaping () -> Void) {
        let ref = Firebase.Database.database().reference().child("users")
        var users: [User] = []
        
        ref.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String:Any], let name = dictionary["name"] as? String, let email = dictionary["email"] as? String, let profileImageUrl = dictionary["profileImageUrl"] as? String {
                let user = User(name: name, email: email, profileImageUrl: profileImageUrl, id: snapshot.key)
                
                if snapshot.key == Auth.auth().currentUser?.uid {
                    self.myProfile = user
                } else {
                    users.append(user)
                    users = users.sorted { $0.name < $1.name }
                }
            }
            self.users = users
            completionHandler()
        }, withCancel: nil)
    }
    
    func handleLogin(email: String, password: String, completionHandler: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else { return }
            completionHandler()
        }
    }
    
    func handleRegister(name: String, email: String, password: String, profileImageView: UIImageView, completionHandler: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let uid = result?.user.uid, error == nil else { return }
            
            let imageName = UUID().uuidString
            let storageRef = FirebaseStorage.Storage.storage().reference().child("Profile_Images").child("\(imageName)")
            if let uploadData = profileImageView.image!.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil) { metadata, error in
                    guard error == nil, let _ = metadata else { return }
                    storageRef.downloadURL { url, error in
                        guard error == nil, let url = url?.absoluteString else { return }
                        
                        let ref = Database.database().reference()
                        let userReference = ref.child("users").child(uid)
                        let values = ["name":name, "email":email, "profileImageUrl":url]

                        userReference.updateChildValues(values) { error, ref in
                            guard error == nil else { return }
                            print("name: \(name), email: \(email) Created!!")
                            completionHandler()
                        }
                    }
                }
            }
        }
    }
}
