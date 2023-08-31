//
//  List.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/24.
//

import Foundation

struct List: Codable {
    var id: UUID = UUID()
    var title: String?
    var date: Date
    var content: String?
    var iscompleted: Bool
    var category: Category
}

enum Category: String, Codable, CaseIterable {
    case none
    case work
    case life
    
    func toIndex() -> Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
    
    static func category(from index: Int) -> Self? {
        Self.allCases.indices ~= index ? Self.allCases[index] : nil
    }
}
