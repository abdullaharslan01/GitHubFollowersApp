//
//  FollowerListVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class FollowerListVC: UIViewController {

    enum Section {
        case main
    }
    
    
    var username: String!
    var collectionView: UICollectionView!
    var followers: [Follower] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

   
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
       configureViewController()
       configureCollectionView()
       getFollowers()
       configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView(){
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {

        let width                        = view.bounds.width
        let padding:CGFloat              = 12
        let minimumItemSpacing: CGFloat  = 10
        let avaliableWidth               = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                    = avaliableWidth / 3
        
        let flowLayout                   = UICollectionViewFlowLayout()
        flowLayout.sectionInset          = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        flowLayout.itemSize              = CGSize(width: itemWidth, height: itemWidth + 40)
        
            return flowLayout
    }
    
    
    func getFollowers(){
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self]  result in
                 
                   switch result {
                   case .success(let followers):
                       self?.followers = followers
                       self?.updateData()
                       break
                   case .failure(let failure):
                       self?.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: failure.rawValue, buttonTitle: "OK")
                       break
                   }
                 
               }

    }
    

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }

    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)

        }
    }
    
}
