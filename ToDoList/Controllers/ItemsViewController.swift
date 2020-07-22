//
//  ItemsViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    //Configuring standard UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
    }

//MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if item.done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
        
// Ternary operator ===>
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }

//MARK: - TableView Delegate Methods

    //Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
    }
    
    
//MARK: - Add New Items
    
    @IBAction func AddItemsButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //What will happen once the user click the Add Item button on our UIAlert.
            let newItem = Item()
            newItem.title = alertTextField.text!
            if alertTextField.text! != "" {
                self.itemArray.append(newItem)
            }
            
            self.saveItems()
            
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
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
        
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}
