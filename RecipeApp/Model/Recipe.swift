//
//  Recipe.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import Foundation

// Due to Swift 4's new Codable type, most of the JSON wrapping functionality is provided automatically
// Due to time constraints, the implementation here does not use any sort of caching for the ingredients list,
//   which is quite memory consuming.
class Recipe: Codable {
    
    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
    
    lazy var ingredientList: [String] = ingredients.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
    
}
