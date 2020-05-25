//
//  Data.swift
//  testProject
//
//  Created by 呂冠勳 on 5/6/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
