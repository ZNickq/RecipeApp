//
//  ViewController.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import UIKit

/**
 Due to the 2 hour time constraint, the code is not as polished as it could be, I tried to showcase a bit of everything I could with the task at hand. JSON Decoding is handled through Swift 4's Codable type, while networking is done through Alamofire.
 
 Normally I would use MVVM/MVP for separating the logic, however that felt trivial to add, so in the limited time I focused on adding the UITableView section header.
 
 The next features I was going to add were infinite scrolling through pagination and performing searches according to the selected filter tags, but unfortunately there wasn't enough time.
 */
class MainViewController: UITableViewController {
    
    private var searchController: UISearchController!
    private var ingredientHeaderView: IngredientHeaderView?
    
    private var recipeList: [Recipe] = [] {
        didSet {
            ingredientHeaderView?.update(for: self.recipeList)
            self.tableView.reloadData()
        }
    }
    
    var filteredRecipeList: [Recipe] {
        guard let ingredientHeaderView = ingredientHeaderView else {
            return recipeList
        }
        if ingredientHeaderView.filteredIngredients.count == 0 {
            return recipeList
        }
        return recipeList.filter { !ingredientHeaderView.filteredIngredients.intersection($0.ingredientList).isEmpty }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
        self.setupHeaderView()
        self.setupTableView()
        
        updateSearch(query: "") // Some initial results
    }
    
    private func setupSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.searchBarStyle = .minimal
        
    }
    
    private func setupHeaderView() {
        guard let contentView = Bundle.main.loadNibNamed("IngredientHeaderView", owner: nil, options: nil)?[0] as? IngredientHeaderView else {
            return
        }
        contentView.delegate = self
        self.ingredientHeaderView = contentView
    }
    
    private func setupTableView() {
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tableFooterView = UIView()
    }
    
    // Mark - UITableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ingredientHeaderView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)
        
        var contentView = cell.contentView.subviews.first { $0 is SingleRecipeView } as? SingleRecipeView
        
        if contentView == nil {
            contentView = Bundle.main.loadNibNamed("SingleRecipeView", owner: nil, options: nil)?[0] as? SingleRecipeView
            contentView?.frame = cell.bounds
            
            if let toAdd = contentView {
                cell.contentView.addSubview(toAdd)
            }
        }
        contentView?.configure(for: filteredRecipeList[indexPath.row])
        
        return cell
    }
    
    private func updateSearch(query: String) {
        Networking.getResults(query: query, ingredients: []) { (recipes) in
            self.recipeList = recipes
        }
    }
 

}

extension MainViewController: IngredientHeaderViewDelegate {
    
    func filterUpdated() {
        self.tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        updateSearch(query: text)
    }
    
    
}
