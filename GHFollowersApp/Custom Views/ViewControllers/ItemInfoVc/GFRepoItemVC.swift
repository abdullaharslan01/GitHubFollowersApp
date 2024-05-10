//
//  GFRepoItemVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 9.05.2024.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoTYpe: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoTYpe: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
    

   

}
