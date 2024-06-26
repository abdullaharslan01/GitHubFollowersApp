//
//  FollowerListVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject{
    
    func didRequestFollers(for username: String)
}



class FollowerListVC: UIViewController {

    enum Section { case main }
    
    
    var username: String!
    var collectionView: UICollectionView!
    var followers: [Follower] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    var filteredFollowers: [Follower] = []
    var hasMoreFollowers: Bool = true
    var page: Int = 1
    var isSearching = false
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
       configureSearchController()
       configureViewController()
       configureCollectionView()
       getFollowers(username: username, page: page)
       configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        navigationItem.rightBarButtonItem = addButton
    }
    
  
    
    func configureCollectionView(){
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    
   
    
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self]  result in
             
            
            guard let self = self else {return}
            dismissLoadingView()

                   switch result {
                   case .success(let followers):
                       if followers.count < 100 {
                           self.hasMoreFollowers = false
                       }
                       self.followers.append(contentsOf: followers)
                       
                       if self.followers.isEmpty {
                           let message = "This user doesn't have any followers. Go follow them."
                           DispatchQueue.main.async{
                               self.showEmptyStateView(with: message, in: self.view)
                               return
                           }
                       }
                       
                       self.updateData(on: self.followers)
                       break
                   case .failure(let failure):
                       self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: failure.rawValue, buttonTitle: "OK")
                       break
                   }
                 
               }
        
       

    }
    
    
    @objc func addButtonTapped(){
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) {[weak self] error in
                    guard let self = self else {
                        return
                    }
                    
                    
                    guard let error = error else{
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user.", buttonTitle: "Hooray!")
                        return
                    }
                    
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
                
                
                
            case .failure(let failure):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: failure.rawValue, buttonTitle: "Ok")
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
 
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot,animatingDifferences: true)

        }
    }
    
    func configureSearchController(){
        let searchController           = UISearchController()
        searchController.searchResultsUpdater           = self
        searchController.searchBar.delegate             = self
        searchController.searchBar.placeholder          = "Search for a username"
        navigationItem.searchController                 = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        
    }
    
}

extension FollowerListVC: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height           = scrollView.frame.size.height
    
        if offsetY > contentHeight - height {
            
            guard hasMoreFollowers else {return}
            
            page += 1
            getFollowers(username: username, page: page)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray  = isSearching ? filteredFollowers : followers
        let follower     = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.followerListVCDelegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
        
        
    }
    
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
        
        isSearching = false
        updateData(on: self.followers)
        
        return}
        isSearching = true
        
        filteredFollowers = followers.filter({$0.login.lowercased().contains(filter.lowercased())})
    
        updateData(on: filteredFollowers)


    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
        isSearching = false
    }
    
    
}

extension FollowerListVC: FollowerListVCDelegate{
    
    func didRequestFollers(for username: String) {

        self.username = username
        title         = username
        page          = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
       getFollowers(username: username, page: page)
    }
    
    
}
