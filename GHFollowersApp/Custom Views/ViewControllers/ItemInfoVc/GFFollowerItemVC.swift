//
//  GFFollowerItemVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 9.05.2024.
//



import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoTYpe: .follower, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoTYpe: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Fallowers")
        
    }
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
    

   

}

