//
//  UserInfoVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 9.05.2024.
//

import UIKit

protocol UserInfoVCDelegate : AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}


class UserInfoVC: UIViewController{
    
    var username: String!
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GFBodyLabel(textAligment: .center)
    var itemViews: [UIView] = []
    
    weak var followerListVCDelegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        getUserInfo()
        layoutUI()
        
    }
    
    
    func setupNavBar(){
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))

        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func getUserInfo(){
        
        NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
            guard let self  = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async{self.configureUIElements(with: user) }
                break
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: failure.rawValue, buttonTitle: "Ok")
                break
            }
        }
        
    }
    
    func configureUIElements(with user: User) {
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        
        let repoItemVC                  = GFRepoItemVC(user: user)
        let followerItemVC              = GFFollowerItemVC(user: user)
        repoItemVC.delegate             = self
        followerItemVC.delegate         = self
        
        self.add(childVC:repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        
        self.dateLabel.text = "GitHub Since \(user.createdAt.contvertToDisplayFormat())"
    }
    
    
    
    @objc func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
   
    
    
    func layoutUI(){
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView,itemViewOne,itemViewTwo, dateLabel]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
               itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
               itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding ),
            ])
        }
        
       

        NSLayoutConstraint.activate([
            
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 180),
            
            
        itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
        itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
        
        itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
        itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
        
        dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
        dateLabel.heightAnchor.constraint(equalToConstant: 18)
        
        
        
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame  = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
}



extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(with: url)
       
    }
    
    func didTapGetFollowers(for user: User) {
        
        guard user.followers != 0 else {
            
            presentGFAlertOnMainThread(title: "No followerds", message: "This user has no followers. What a shame.", buttonTitle: "Ok")
            return
        }
        
        followerListVCDelegate.didRequestFollers(for: user.login)
        dismiss(animated: true)
        
    }
    
}
