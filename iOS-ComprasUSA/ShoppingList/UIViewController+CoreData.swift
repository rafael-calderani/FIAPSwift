//
//  UIViewController+CoreData.swift
//  ShoppingList
//
//  Created by Rafael dos Santos Calderani on 16/10/17.
//  Copyright © 2017 Rafael dos Santos Calderani. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
