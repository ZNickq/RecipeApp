//
//  RecipeCellView.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

// I normally use the pattern of keeping UITableViewCells empty of view logic and creating custom views
// in their own separate xibs, this allows re-using the UIView subclasses wherever they may be necessary.
class SingleRecipeView: UIView {
    
    @IBOutlet weak var recipeThumbnail: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeThumbnail.layer.cornerRadius = 10.0
    }
    
    func configure(for recipe: Recipe) {
        recipeTitle.text = recipe.title
        
        recipeThumbnail.af_cancelImageRequest()
        if let imageURL = URL(string: recipe.thumbnail) {
            recipeThumbnail.isHidden = false
            recipeThumbnail.af_setImage(withURL: imageURL)
        } else {
            recipeThumbnail.isHidden = true
        }
    }
    
}
