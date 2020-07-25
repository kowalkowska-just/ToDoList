//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }

    //MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].title
        
        return cell
    }
    
    //Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

//MARK: - Add New Category
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
            
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Categgry", style: .default) { (action) in
               
//What will happen once the user click the Add Item button on our UIAlert.
            
            
            
        let newCategory = Category(context: self.context)
            newCategory.title = alertTextField.text!
            if newCategory.title != "" {
            self.categoryArray.append(newCategory)
        }
                
        self.saveCategory()
                
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
    
//MARK: - Core Data Functions
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadCategory() {

            do {
                categoryArray = try context.fetch(Category.fetchRequest())
            } catch {
                print("Error fetching data from context: \(error)")
            }

        tableView.reloadData()
    }
    
}

