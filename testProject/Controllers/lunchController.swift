//
//  lunchController.swift
//  testProject
//
//  Created by 呂冠勳 on 5/4/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RealmSwift


class lunchController: UIViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Lunch.plist")
    
    var res: Results<Lunch>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Lunch]()
    let realm = try! Realm()
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        
//        self.loadItems()
    }
    
    @IBAction func pressedRoll(_ sender: Any) {
        loadItems()
        var output: [String] = []
        for item in res! {
            if item.done == true {
//                print(item.title!)
                output.append(item.title)
            }
        }
        textView.text = output.randomElement()
    }
    
    func loadItems() {
        res = realm.objects(Lunch.self)
    }
    
    
    // Coredata load
//    func loadItems() {
//        // 特殊情況！ 要specify data type
//
//        // fetch 所有的資料
//        let request: NSFetchRequest<Lunch> = Lunch.fetchRequest()
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data context \(error)")
//        }
//
//    }
    
    
    // 一樣，這是給decoder讀取檔案用的
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
}
