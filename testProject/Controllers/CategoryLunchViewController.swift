//
//  CategoryLunchViewController.swift
//  testProject
//
//  Created by 呂冠勳 on 5/6/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework
//import SwipeCellKit


class CategoryLunchViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    // CoreDate 讀取一行一行category方法
//    var categories = [Category]()
    
    // CoreData 用法
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        // Coredata load 法
//        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        navBar.barTintColor = UIColor(hexString: "1D9BF6")
        if let navBarColor = UIColor(hexString: "1D9BF6") {
           
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        }
       
    }
    
    // MARK: - ADD NEW CATEGORY
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "增加餐廳種類", message: "今天想吃什麼類型餐點", preferredStyle: .alert)
        let action = UIAlertAction(title: "增加", style: .default) {
            // 當使用者按下 +, 才會trigger
            (action) in
            
            // Realm 存法
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            // Realm的Results data type 會自動存起新東西，不用在append
            self.save(category: newCategory)
            
            // 這是CoreData的用法
//            let category = Category(context: self.context)
//            category.name = textField.text!
//            self.categories.append(newCategory)
//            self.saveItems()
            
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "請輸入種類"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return categories?.count ?? 1
        // coredata寫法，categories 不是Result<> 而是一個array
//        return categories.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "沒有種類"
            guard let categoryColor = UIColor(hexString: category.color)  else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        
        // 這是不gener的寫法，在swipeCell之前
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "沒有種類"
//        cell.delegate = self
        
        // coredata categores 還是陣列
//        let category = categories[indexPath.row].name
//        cell.textLabel?.text = category.name
        
        
        return cell
    }
    
    // MARK: - Data Manipulate Methods
    
    // Realm 存法
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category. \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        // fetch all the category object in realm
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // Mark - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    // CoreData 存法
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    // CoreData 讀法
//    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        // 特殊情況！ 要specify data type
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching data context \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    // MARK: - TablewView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToLunch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! listViewControlloer

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categories?[indexPath.row]
//            print(categories?[indexPath.row])
            // coredata, categories 此時array 不是Results data type
            //destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    
}
