//
//  Networking.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import Foundation
import Alamofire

// Normally I would create a more complex networking stack, usually using a Request enum with associated values for the params, however this class works well enough for the required task.
class Networking {
    
    private static let rootURL = "http://www.recipepuppy.com/api";
    private static let decoder = JSONDecoder()
 

    public static func getResults(query: String, ingredients: [String] = [], completion: (([Recipe]) -> Void)? = nil) {
        let allIngredients = ingredients.reduce("") { "\($0),\($1)" }
        let parameters: [String: Any] = ["q":query,"p":1,"i": allIngredients]
        
        Alamofire.request(rootURL, parameters:parameters).responseJSON { response in
            guard let json = (response.result.value as AnyObject).value(forKeyPath: "results") else {
                completion?([])
                return
            }
            guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                completion?([])
                return
            }
            guard let allRecipes = try? decoder.decode([Recipe].self, from: data) else {
                completion?([])
                return
            }
            completion?(allRecipes)
            
        }
    }
    
}
