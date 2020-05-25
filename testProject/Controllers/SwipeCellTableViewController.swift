//
//  SwipeCellTableViewController.swift
//  testProject
//
//  Created by 呂冠勳 on 5/15/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
               
        cell.delegate = self
                
                // coredata categores 還是陣列
        //        let category = categories[indexPath.row].name
        //        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // 當使用者往右滑，必且按下delete 按鈕
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //            print("Delete item")
            
            // 觸發updateModel 讓sub class 寫override去刪掉cell
            // 呼叫被override的methods，原本class不會被呼叫，只有subclass會呼叫
            self.updateModel(at: indexPath)
            
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                } catch {
//                    print("Error deleting category, \(error)")
//                }
//
//                // 在下面那個options.expansionStyle = .destructive 會remove掉last row，所以必須助解掉reloadData不然會有bug
//                //                tableView.reloadData()
//            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Upate data model
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
}
