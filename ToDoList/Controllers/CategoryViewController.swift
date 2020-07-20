//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    let categoryArray = ["Learn", "Home", "Work", "Eat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - TableViewDataSour
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row]
        
        return cell
    }
    
    //Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

