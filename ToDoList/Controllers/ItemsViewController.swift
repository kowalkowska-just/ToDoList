//
//  ItemsViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    var itemsArray = ["GIT", "Swift", "Objectiv-C", "Jira"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

//MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }

//MARK: - TableView Delegate Methods

    //Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    
//MARK: - Add New Items
    
    @IBAction func AddItemsButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user click the Add Item button on our UIAlert.
            
            if alertTextField.text! != "" {
                self.itemsArray.append(alertTextField.text!)
            }
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .light
            textField.keyboardType = .default
            textField.placeholder = "Enter your new item"
            textField.backgroundColor = UIColor.init(named: "LightGreenColor")
            textField.textColor = UIColor.init(named: "DarkGreenColor")
            textField.font = UIFont(name: "AmericanTypewriter", size: 19)
            
            alertTextField = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
