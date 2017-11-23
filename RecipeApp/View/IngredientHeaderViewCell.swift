//
//  IngredientHeaderViewCell.swift
//  RecipeApp
//
//  Created by Zloteanu Nikita on 11/22/17.
//  Copyright © 2017 nichita. All rights reserved.
//

import Foundation
import UIKit

protocol IngredientHeaderViewCellDelegate: class {
    
    func cellTapped(cell: IngredientHeaderViewCell)
    
}

class IngredientHeaderViewCell: UIView {
    
    enum IngredientCellState {
        case enabled
        case disabled
    }
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var ingredientLabel: UILabel!
    
    weak var delegate: IngredientHeaderViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 5.0
        backView.layer.borderWidth = 1.0
    }
    
    @IBAction func toggleState(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.state = self.state == .enabled ? .disabled : .enabled
            self.layoutIfNeeded()
        }) { (_) in
            self.delegate?.cellTapped(cell: self)
        }
    }
    
    var state: IngredientCellState = .disabled {
        didSet{
            self.updateForState()
        }
    }
    
    public func configure(for text: String) {
        self.layer.cornerRadius = 5.0
        self.ingredientLabel.text = text
    }
    
    private func updateForState() {
        if state == .enabled {
            ingredientLabel.textColor = .white
            backView.layer.borderColor = UIColor.clear.cgColor
            backView.backgroundColor = UIColor(hex: 0x48203B)
        } else {
            ingredientLabel.textColor = .black
            backView.layer.borderColor = UIColor(hex: 0x48203B).cgColor
            backView.backgroundColor = .clear
        }
    }
    
    var text: String {
        return ingredientLabel.text ?? ""
    }
    
}
