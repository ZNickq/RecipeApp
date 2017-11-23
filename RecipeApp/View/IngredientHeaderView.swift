//
//  IngredientHeaderView.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import Foundation
import UIKit

protocol IngredientHeaderViewDelegate: class {
    
    func filterUpdated()
    
}

// The UICollectionView was originally supposed to dynamically resize itself based on the UILabel contentSize, however the support for self-sizing cells in CollectionView was hard to implement in 3 hours, so at the moment they are capped at W: 130
class IngredientHeaderView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    weak var delegate: IngredientHeaderViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "aCell")
    }
    
    private var ingredients: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private(set) var filteredIngredients = Set<String>()
    
    public func update(for recipes: [Recipe]) {
        // Clear the filtered array
        filteredIngredients.removeAll()
        
        // Split the ingredients into a single array, and remove duplicates from it
        let resulting = Set(recipes.flatMap { $0.ingredientList })
        ingredients = resulting.sorted()
    }
    
    
}

extension IngredientHeaderView: IngredientHeaderViewCellDelegate {
    
    func cellTapped(cell: IngredientHeaderViewCell) {
        let ingredientFilter = cell.text
        if filteredIngredients.contains(ingredientFilter) {
            filteredIngredients.remove(ingredientFilter)
        } else {
            filteredIngredients.insert(ingredientFilter)
        }
        delegate?.filterUpdated()
    }
    
}

extension IngredientHeaderView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aCell", for: indexPath)
        
        if genericCell.contentView.subviews.isEmpty {
            if let headerViewCell = Bundle.main.loadNibNamed("IngredientHeaderViewCell", owner: nil, options: nil)?[0] as? IngredientHeaderViewCell {
                headerViewCell.frame = genericCell.contentView.bounds
                headerViewCell.delegate = self
                genericCell.contentView.addSubview(headerViewCell)
            }
        }
        
        guard let headerViewCell = genericCell.contentView.subviews.first as? IngredientHeaderViewCell else {
            return genericCell
        }
        
        let value = ingredients[indexPath.row]
        headerViewCell.configure(for: value)
        
        headerViewCell.state = filteredIngredients.contains(value) ? .enabled : .disabled
        
        return genericCell
    }

}
