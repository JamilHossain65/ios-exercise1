//
//  TableDatasource.swift
//  my-cooking
//
//  Created by Vladas Drejeris on 16/09/2019.
//  Copyright © 2019 ito. All rights reserved.
//

import UIKit

class TableDatasource<Element>: NSObject, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Dependencies

    var configureCell: (Element, UITableViewCell) -> Void = { _, _ in }
    var didSelectElement: (Element) -> Void = { _ in }

    // MARK: - State

    var elements: [Element] = []

    // MAKR: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mode :Difficulty = .easy
        switch section {
        case 0:
            mode = .easy
        case 1:
            mode = .normal
        default:
            mode = .hard
        }
        
        let filtedRecpies = elements.filter{($0 as! Recipe).dificulty == mode}
        return filtedRecpies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let cellIdentifier = "RecipeCell"
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        var mode :Difficulty = .easy
        switch indexPath.section {
        case 0:
            mode = .easy
        case 1:
            mode = .normal
        default:
            mode = .hard
        }
        
        let filtedRecpies = elements.filter{($0 as! Recipe).dificulty == mode}
        let element = filtedRecpies[indexPath.row]
        configureCell(element, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let element = elements[indexPath.row]
        didSelectElement(element)
    }
    
    //MARK: - Private Methods
    func getRecipes(mode:Difficulty) -> [Element] {
        let filtedRecpies = elements.filter{($0 as! Recipe).dificulty == mode }
        return filtedRecpies
    }

}
