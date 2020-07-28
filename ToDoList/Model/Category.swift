//
//  Category.swift
//  ToDoList
//
//  Created by Justyna Kowalkowska on 28/07/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
