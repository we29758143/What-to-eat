//
//  Meal.swift
//  testProject
//
//  Created by 呂冠勳 on 5/17/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import Foundation
import RealmSwift

class Meal: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    // 創到一個由上往下的連結
    let Categories = List<Category>() //創建一個全新的empty list
}
