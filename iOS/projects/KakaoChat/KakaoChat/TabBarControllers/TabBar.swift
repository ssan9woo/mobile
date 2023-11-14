//
//  TabBar.swift
//  KakaoChat
//
//  Created by 석상우 on 2021/06/04.
//

import UIKit

class TabBar: UITabBarController {
    
    let imageNames = ["person", "message", "newspaper", "ellipsis.circle"]
    let selectedImageNames = ["person.fill", "message.fill", "newspaper.fill", "ellipsis.circle.fill"]
    let profileVC: UIViewController = {
        let vc = UINavigationController(rootViewController: ProfileViewController())
        let image = UIImage(systemName: "person")!
        vc.tabBarItem.image = image
        return vc
    }()
    
    let chattingVC: UIViewController = {
        let vc = UINavigationController(rootViewController: ChatLogViewController())
        vc.tabBarItem.image = UIImage(systemName: "message")!
        return vc
    }()
    
    let newsVC: UIViewController = {
        let vc = UINavigationController(rootViewController: NewsViewController())
        vc.tabBarItem.image = UIImage(systemName: "newspaper")!
        return vc
    }()
    
    let settingVC: UIViewController = {
        let vc = UINavigationController(rootViewController: SettingViewController())
        vc.tabBarItem.image = UIImage(systemName: "ellipsis.circle")!
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setupViewController()
    }
    
    func setTabBar() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    func setupViewController() {
        viewControllers = [self.profileVC, self.chattingVC, self.newsVC, self.settingVC]
        tabBar.items?[0].image = UIImage(systemName: "person.fill")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            for i in 0..<imageNames.count {
                if index == i {
                    tabBar.items?[i].image = UIImage(systemName: selectedImageNames[i])
                } else {
                    tabBar.items?[i].image = UIImage(systemName: imageNames[i])
                }
            }
        }
    }
}
