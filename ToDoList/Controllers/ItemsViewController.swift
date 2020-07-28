//
//  ItemsViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UITableViewController{
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

//MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added."
        }
        
        return cell
    }

//MARK: - TableView Delegate Methods

    //Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
    }
    
    
//MARK: - Add New Items
    
    @IBAction func AddItemsButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //What will happen once the user click the Add Item button on our UIAlert.
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertTextField.text!
                        currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new Item, \(error)")
                }
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
    
//MARK: - Data Manupulation Methods

    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search bar methods

//extension ItemsViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchBar.text!)
//
//        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        self.loadItems(with: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//
//    }
//}
