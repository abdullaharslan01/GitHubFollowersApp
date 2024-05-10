//
//  GFItemInfoView.swift
//  GHFollowersApp
//
//  Created by abdullah on 9.05.2024.
//

import UIKit


enum ItemInfoType {
    case repos, gists, follower, following
}

class GFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel      = GFTitleLabel(textAligment: .left, fontsize: 14)
    let countLabel      = GFTitleLabel(textAligment: .center, fontsize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
   private func configure(){
       addSubview(symbolImageView)
       addSubview(titleLabel)
       addSubview(countLabel)
       
       symbolImageView.translatesAutoresizingMaskIntoConstraints = false
       titleLabel.translatesAutoresizingMaskIntoConstraints      = false
       countLabel.translatesAutoresizingMaskIntoConstraints      = false
       
       symbolImageView.contentMode = .scaleAspectFit
       symbolImageView.tintColor   = .label
       
       NSLayoutConstraint.activate([
       
        symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
        symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        symbolImageView.widthAnchor.constraint(equalToConstant: 20),
        symbolImageView.heightAnchor.constraint(equalToConstant: 20),
       
        
        titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 18),
        
        countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
        countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        countLabel.heightAnchor.constraint(equalToConstant: 18)
        
       ])
       
   }
    
    
    func set(itemInfoTYpe: ItemInfoType, withCount count: Int) {
        switch itemInfoTYpe {
        case .repos:
            symbolImageView.image = UIImage(systemName: SFSymbols.repos)
            titleLabel.text       = "Public Repos"
            break
        case .gists:
            symbolImageView.image = UIImage(systemName: SFSymbols.gists)
            titleLabel.text       = "Public Gists"
            break
        case .follower:
            symbolImageView.image = UIImage(systemName: SFSymbols.followers)
            titleLabel.text       = "Followers"
            break
        case .following:
            symbolImageView.image = UIImage(systemName: SFSymbols.following)
            titleLabel.text       = "Following"
            break
        }
        countLabel.text          = String(count)
    }
    
    
}
