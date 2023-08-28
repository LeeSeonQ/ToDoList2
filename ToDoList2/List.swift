//
//  List.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/24.
//

import UIKit

struct List: Codable {
    var id: UUID = UUID()
    var title: String?
    var date: Date
    var content: String?
    var iscompleted: Bool
}
