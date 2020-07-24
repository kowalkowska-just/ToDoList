//
//  ItemsViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController{

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    //Configuring standard UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
                
        //Delete data in CoreData
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
    }
    
    
//MARK: - Add New Items
    
    @IBAction func AddItemsButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            //What will happen once the user click the Add Item button on our UIAlert.
            
            let newItem = Item(context: self.context)
            newItem.title = alertTextField.text!
            if alertTextField.text! != "" {
                newItem.done = false
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
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

            do {
                itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context: \(error)")
            }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension ItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        self.loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}
