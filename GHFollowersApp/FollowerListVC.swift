//
//  FollowerListVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    

}
