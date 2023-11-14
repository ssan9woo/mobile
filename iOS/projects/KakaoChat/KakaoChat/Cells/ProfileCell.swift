//
//  ProfileCell.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/17.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.clipsToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func updateCell(user: User) {
        nameLabel.text = user.name
        subTitleLabel.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
    }
    
    func setConstraint() {
        let constraint = [
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            subTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 200),
            subTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            timeStampLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeStampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(subTitleLabel)
        addSubview(profileImageView)
        addSubview(timeStampLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
