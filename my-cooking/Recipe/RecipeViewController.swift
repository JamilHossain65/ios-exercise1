//
//  RecipeViewController.swift
//  my-cooking
//
//  Created by Vladas Drejeris on 16/09/2019.
//  Copyright © 2019 ito. All rights reserved.
//

import UIKit
import AlamofireImage

class RecipeViewController: UIViewController {

    // MAKR: - UI componenets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var difficultyLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!

    // MARK: - Dependencies

    private let repository = DishesRepository.shared
    private let recipes = RecipesRepository.shared

    // MARK: - State

    var recipe: Recipe!
    let recentAssume = 3
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        display(recipe: recipe)
        
        //remove more than 2
        if recipes.recentRecipes.count >= recentAssume {
            recipes.recentRecipes.removeLast()
        }
        //set difficuty type
        recipes.recentRecipes.append(recipe.dificulty)
        print("recentRecipes count::\(recipes.recentRecipes.count)")
        
        var tempList = recipes.recentRecipes
        
        
        if tempList.count > 1 {
            recipes.recommendedType = tempList.last!
            repeat {
                if tempList.count > 1{
                    let firstType = tempList.last!
                    tempList.removeLast()
                    for type in tempList {
                        if type == firstType{
                            recipes.recommendedType = type
                        }
                    }
                   print("remove difficulty::\(tempList)")
                }
            } while tempList.count >= 2;
            
            print("recent difficulty::\(recipes.recommendedType)")
            
        }
        
        
        if recipes.recentRecipes.count > 0 {
            //recipes.recommendedType = recipes.recentRecipes.last!
        }
        
    }

    private func display(recipe: Recipe) {

        titleLabel.text = recipe.title
        difficultyLabel.text = recipe.dificulty.localizedString
        difficultyLabel.textColor = recipe.dificulty.color
        textLabel.text = recipe.text

        if let imageUrl = recipe.image {
            imageView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder_big"))
        } else {
            imageView.image = UIImage(named: "placeholder_big")
        }
    }

    // MARK: - Actions

    @IBAction func saveAttemptedRecipe(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("save_attempt_sheet_title", comment: ""),
                                      message: NSLocalizedString("save_attempt_sheet_message", comment: ""),
                                      preferredStyle: .actionSheet)
        for result in CookingResult.allCases {
            alert.addAction(UIAlertAction(title: result.localizedString,
                                          style: .default,
                                          handler: { (_) in
                                            self.saveAttempt(with: result)
            }))
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func saveAttempt(with result: CookingResult) {
        let dish = Dish(id: UUID(), recipe: recipe, result: result)
        repository.save(dish: dish)
    }

}
