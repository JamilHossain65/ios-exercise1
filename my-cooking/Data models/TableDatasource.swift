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
    
    var elements: [Int:[Element]] = [:]

    // MAKR: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return elements.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements[section]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let cellIdentifier = "RecipeCell"
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        if let sectionElement = elements[indexPath.section] {
            let element = sectionElement[indexPath.row]
            configureCell(element, cell)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectionElement = elements[indexPath.section] else { return }
        let element = sectionElement[indexPath.row]
        didSelectElement(element)
    }
}
