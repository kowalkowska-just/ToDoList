//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categoriesArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

//MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories added yet."
        
        return cell
    }
    

//MARK: - Table View Delegate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ItemsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }

//MARK: - Add New Categories
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
            
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Categgry", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = alertTextField.text!
   
            self.save(category: newCategory)
        }
            
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .light
            textField.keyboardType = .default
            textField.placeholder = "Enter your new category"
            textField.backgroundColor = UIColor.init(named: "LightGreenColor")
            textField.textColor = UIColor.init(named: "DarkGreenColor")
            textField.font = UIFont(name: "AmericanTypewriter", size: 19)
                
            alertTextField = textField
        }
            
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
            
        }
    
//MARK: - Data Manupulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }

    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}

