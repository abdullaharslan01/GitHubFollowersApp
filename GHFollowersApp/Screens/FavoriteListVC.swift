//
//  FavoriteListVC.swift
//  GHFollowersApp
//
//  Created by abdullah on 5.05.2024.
//

import UIKit

class FavoriteListVC: UIViewController {

    let tableView             = UITableView()
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    

    func getFavorites(){
        PersistenceManager.retrieveFavorites {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let favorites):
                
                self.favorites = favorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
                
                break
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    
    func configureTableView(){
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.delegate      = self
        tableView.dataSource    = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
       
        
    }
    
    
    func configureViewController(){
        view.backgroundColor   = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension FavoriteListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        
        cell.set(favorite: favorites[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite      = favorites[indexPath.row]
        let destVC        = FollowerListVC()
        destVC.username   = favorite.login
        destVC.title      = favorite.login
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            
            let favorite = self.favorites[indexPath.row]
            
            self.favorites.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .left)
            
            PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            }
            
        }
     
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
        

    


