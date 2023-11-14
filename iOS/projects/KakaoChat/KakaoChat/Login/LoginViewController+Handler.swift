//
//  LoginController+Handler.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/03.
//

import Foundation
import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        
        spinner.startAnimating()
        FirebaseAuthManager.shared.handleLogin(email: email, password: password) {
            FirebaseAuthManager.shared.fetchUsers {
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleRegister() {
        guard let name = nameTF.text, let email = emailTF.text, let password = passwordTF.text else { return }
        
        // animation start
        spinner.startAnimating()
        FirebaseAuthManager.shared.handleRegister(name: name, email: email, password: password, profileImageView: profileImageView) {
            FirebaseAuthManager.shared.fetchUsers {
                // animation end
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func handleSelectProfileImage() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
