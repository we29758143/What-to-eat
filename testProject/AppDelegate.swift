//
//  AppDelegate.swift
//  testProject
//
//  Created by 呂冠勳 on 5/4/20.
//  Copyright © 2020 KuanHsun Lu. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 查看把資料所在哪一個位置
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        // 找到查看realm把資料存在哪
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       
        
        do {
            let realm = try Realm()
            // commiet current database
        } catch {
            print("Error initialising new realm, \(error)")
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack

       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "dataModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
            
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }

}

