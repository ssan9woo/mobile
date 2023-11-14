//
//  LoginController.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/02.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let defaultProfileImage: UIImage = UIImage(named: "defaultProfileImage")!
    let inputContainerView = UIView()
    let loginRegisterButton = UIButton(type: .system)
    var nameTF = UITextField()
    var emailTF = UITextField()
    var passwordTF = UITextField()
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: Constraint
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTFHeightAnchor: NSLayoutConstraint?
    var emailTFHeightAnchor: NSLayoutConstraint?
    var passwordTFHeightAnchor: NSLayoutConstraint?
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "kakao_talk"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login", "Register"])
        segment.tintColor = .white
        segment.layer.cornerRadius = 10
        segment.layer.masksToBounds = true
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(handleLoginResigerChange), for: .valueChanged)
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView() {
        view.backgroundColor = UIColor(r: 247, g: 230, b: 0)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(spinner)
        
        setInputContainerView()
        setLoginRegisterButton()
        setTFInContainerView()
        setProfileImageView()
        setLoginRegisterSegmentControl()
        setSpinner()
        
        loginRegisterSegmentedControl.selectedSegmentIndex = 0
        handleLoginResigerChange()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        profileImageView.isUserInteractionEnabled = true
    }
    
    func setSpinner() {
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func handleLoginResigerChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // set Profile Image View
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            profileImageView.image = UIImage(named: "kakao_talk")
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = 0
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = 25
        }
        
        
        // change inputContainer Height
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change nameTF Height
        nameTFHeightAnchor?.isActive = false
        nameTFHeightAnchor = nameTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTFHeightAnchor?.isActive = true
        
        // change emailTF Height
        emailTFHeightAnchor?.isActive = false
        emailTFHeightAnchor = emailTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTFHeightAnchor?.isActive = true
        
        // change passwordTF Height
        passwordTFHeightAnchor?.isActive = false
        passwordTFHeightAnchor = passwordTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTFHeightAnchor?.isActive = true
    }
    
    func setLoginRegisterSegmentControl() {
        let constraint = [
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    
    func setInputContainerView() {
        inputContainerView.backgroundColor = .white
        inputContainerView.layer.cornerRadius = 10
        inputContainerView.layer.masksToBounds = true
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        
        let constraint = [
            inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
        ]
        NSLayoutConstraint.activate(constraint)
        inputContainerViewHeightAnchor?.isActive = true
    }
    
    func setLoginRegisterButton() {
        loginRegisterButton.backgroundColor = UIColor(r: 58, g: 29, b: 29)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginRegisterButton.setTitleColor(.white, for: .normal)
        loginRegisterButton.layer.cornerRadius = 10
        loginRegisterButton.layer.masksToBounds = true
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        let constraint = [
            loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 70),
            loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20),
            loginRegisterButton.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    func setTFInContainerView() {
        nameTF = getInputTextField(title: "Name")
        emailTF = getInputTextField(title: "Email Address")
        passwordTF = getInputTextField(title: "Password")
        
        let nameSeparatorView = nameSeparatorView
        let emailSeparatorView = emailSeparatorView
        
        inputContainerView.addSubview(nameTF)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTF)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTF)
        
        nameTFHeightAnchor = nameTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTFHeightAnchor = emailTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTFHeightAnchor = passwordTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        
        let constraint = [
            nameTF.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            nameTF.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            nameTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            nameTFHeightAnchor!,
            
            nameSeparatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTF.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            emailTF.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            emailTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor),
            emailTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            emailTFHeightAnchor!,
            
            emailSeparatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTF.bottomAnchor),
            emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            passwordTF.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor),
            passwordTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            passwordTFHeightAnchor!
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    func getInputTextField(title: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = title
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = title == "Password"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }
    
    func setProfileImageView() {
        let constraint = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -40),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(constraint)
    }
}
