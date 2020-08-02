//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 13/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categoriesArray: Results<Category>?
    
    var selectedColor: String = ""
    
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var FFC107button: UIButton!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = 60.0
        
        //Button border runding
        colorButtons.forEach({ $0.layer.cornerRadius = 0.45 * $0.bounds.size.width })
        
        loadCategories()
        
        FFC107button.layer.borderWidth = CGFloat(2.5)
        FFC107button.layer.borderColor = UIColor.black.cgColor
        selectedColor = "#FFC107"
    }

    
//MARK: - Selected Color
    
    @IBAction func selectedColor(_ sender: UIButton) {
       // colorButtons.forEach({ $0.isSelected = false })
        colorButtons.forEach({ $0.layer.borderWidth = CGFloat(0) })
        
       // sender.isSelected = true
        sender.layer.borderWidth = CGFloat(2.5)
        sender.layer.borderColor = UIColor.black.cgColor
        selectedColor = "#\(sender.currentTitle!)"
    }
    
//MARK: - TableView DataSource Methods
    
    //Number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    //Contents of the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        cell.contentView.backgroundColor =
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories added yet."
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = backgroundView
        
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
    
    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {

        let newCategory = Category()
        newCategory.name = categoryTextField.text!
        newCategory.color = selectedColor
        self.save(category: newCategory)
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
    
//MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoriesArray?[indexPath.row] {
            try! self.realm.write {
                self.realm.delete(category)
            }
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension UIColor {
    func colorFromHex(_ hex : String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.white
        }
        
        var rgb: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16),
                            green: CGFloat((rgb & 0x00FF00) >> 8),
                            blue: CGFloat(rgb & 0x0000FF),
                            alpha: 1.0)
    }
}

//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//        return nil
//    }
//}
