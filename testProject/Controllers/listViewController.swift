//
//  listViewController.swift
//  testProject
//
//  Created by 呂冠勳 on 5/4/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class listViewControlloer: SwipeCellTableViewController {
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var LunchItem : Results<Lunch>?
    // Coredata 存法
//    var itemArray = [Lunch]()
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectCategory : Category? {
        didSet{
            loadLunch()
        }
    }
    
    // 這是找資料存取位置，
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Lunch.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        
        
        
        // 存放在user手機裡面
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        let newLunch = Lunch()
//        newLunch.title = "鴨肉麵"
//        itemArray.append(newLunch)
//
//        let newLunch2 = Lunch()
//        newLunch2.title = "一條通"
//        itemArray.append(newLunch2)
//
//        let newLunch3 = Lunch()
//        newLunch3.title = "a麵"
//        itemArray.append(newLunch3)

        
//        用不到，這是給default的用法
//        if let items = defaults.array(forKey: "restList") as? [Lunch] {
//            itemArray = items
//        }
        
//        loadLunch()
        // coredata load
//        loadItems()
    }
    
    // 出現在view did load 之後
    // 放在view did load 會錯， 因為nav Bar還沒有被讀取，所以會報錯
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectCategory?.color {
            title = selectCategory!.name
//            navigationController?.title = title
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
//            print(colorHex)
            navBar.barTintColor = UIColor(hexString: colorHex)
           
            if let navBarColor = UIColor(hexString: colorHex) {
                searchBar.barTintColor = UIColor(hexString: colorHex)
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            }
        
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return LunchItem?.count ?? 1
//        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // 舊寫法
//        let cell = tableView.dequeueReusableCell(withIdentifier: "lunchList", for: indexPath)
        
        if let lunch = LunchItem?[indexPath.row] {
            cell.textLabel?.text = lunch.title
            cell.accessoryType = lunch.done ? .checkmark : .none
            
          
            // force unwrapp 291 7:00, 291 18:20
            if let color = UIColor(hexString: selectCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(LunchItem!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
          
            
        } else {
            cell.textLabel?.text = "沒有餐廳"
        }
        
        
        // coredata 寫法
//        let item = itemArray[indexPath.row]
//        cell.textLabel?.text = item.title
//        cell.accessoryType = item.done == true ? .checkmark : .none
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let Lunch = LunchItem?[indexPath.row] {
            do {
                try realm.write {
                    Lunch.done = !Lunch.done
                }
            } catch {
                print("Error svaing done status, \(error)")
            }
        }
        
        // CoreData 寫法
//        LunchItem[indexPath.row].done != LunchItem[indexPath.row].done
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//        self.saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "增加新餐廳", message: "來想想今天吃什麼", preferredStyle: .alert)
        let action = UIAlertAction(title: "增加", style: .default) {
            // 當使用者按下 +, 才會trigger
            (action) in
            
            if let currentCategory = self.selectCategory {
                do {
                    try self.realm.write {
                        let newLunch = Lunch()
                        newLunch.title = textField.text!
                        newLunch.dateCreated = Date()
                        currentCategory.Lunches.append(newLunch)
                    }
                } catch {
                    print("Error saving category. \(error)")
                }
            }
            self.tableView.reloadData()
           // Coredata 寫法，寫新東西進去coredata database
//            let newLunch = Lunch(context: self.context)
//            newLunch.title = textField.text!
//            newLunch.done = false
//            newLunch.parentCategory = self.selectCategory
//            self.itemArray.append(newLunch)
//            // 因為default array必須是傳統的datatype ，不能夠用自己創建的object，所以我們用一個ENCODER
////            self.defaults.set(self.itemArray, forKey: "restList")
//            self.saveItems()
//
//            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "請輸入餐廳名字"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    func loadLunch() {
       
        LunchItem = selectCategory?.Lunches.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let listForDeletion = self.selectCategory?.Lunches[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(listForDeletion)
                }
            } catch {
                print("Error deleting list, \(error)")
            }
        }
    }
    
    
    // coredata save法
    //    func saveItems() {
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error saving context \(error)")
    //        }
    //    }
    
    // 後面那個是default寫法
    // 默認predicate是所有的Lunch,
//    func loadItems(with request: NSFetchRequest<Lunch> = Lunch.fetchRequest(), predicate: NSPredicate? = nil) {
//        // 特殊情況！ 要specify data type
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
//
//        // 同時符合兩個需求的predicate
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data context \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    
    
    // 這是用encoder方法來寫入資料的
//    func saveItems() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
//    }
    
    // 這是用decoder方法來寫入資料的
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Lunch].self, from: data)
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
//    }
//}
}

    
    


//MARK: - Search bar method
    
    
extension listViewControlloer: UISearchBarDelegate {
    // 當user點searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        LunchItem = LunchItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        // 這邊需要，因為是以date還做sort會有區別
        tableView.reloadData()
        
        // 根據title 做sorting
//        LunchItem = LunchItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        // 不用呼叫load,因為loadLunch已經呼叫了，在這邊只是做一個filter的動作 284 2:27
        
// Coredata寫法
//        let request : NSFetchRequest<Lunch> = Lunch.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 根據字數user query變化
        if searchBar.text?.count == 0 {
            loadLunch()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
       
        
        
        // Coredata 寫法
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            // 影片274 2:50
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
    }
}
