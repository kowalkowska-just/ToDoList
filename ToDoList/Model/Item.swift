//
//  Item.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 28/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dataCreated : Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
