//
//  Lunch.swift
//  testProject
//
//  Created by 呂冠勳 on 5/6/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import Foundation
import RealmSwift

class Lunch: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    // 創建一個由下往上的連結到Category, property 是 Category class 裡面那個list的名字
    var parentCategory = LinkingObjects(fromType: Category.self, property: "Lunches")
}
