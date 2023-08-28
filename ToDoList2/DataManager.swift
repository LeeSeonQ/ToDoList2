//
//  DataManager.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/24.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}
    
    private var doItList: [List] = [
//        List(id: <#T##UUID#>, title: "", date: <#T##Date#>, content: "", iscompleted: false)
    ]
    
    private let doItListKey = "com.example.app.doItList"
    
    private func saveDoItListToUserDefaults() {
         let encodedData = try? JSONEncoder().encode(doItList)
         UserDefaults.standard.set(encodedData, forKey: doItListKey)
     }
    
    private func loadDoItListFromUserDefaults() {
         if let encodedData = UserDefaults.standard.data(forKey: doItListKey),
             let savedDoItList = try? JSONDecoder().decode([List].self, from: encodedData) {
             doItList = savedDoItList
         }
     }
    
    func createDoItList(title: String, date: Date, content: String, isCompleted: Bool) {
        let newDoIt = List(title: title, date: date, content: content, iscompleted: isCompleted)
        doItList.append(newDoIt)
        saveDoItListToUserDefaults()
    }
    
    func loadDoItList() {
        loadDoItListFromUserDefaults()
    }
    
 
    
    func getTodayDoItList() -> [List] {
        let date = Date()
        let filteredList = doItList.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }.sorted {
            $0.date < $1.date
        }
        return filteredList
    }
    
}
//선택 구현 과제 과정
//    func updateDoItList(data: List) {
//        let index = doItList.firstIndex { $0.id == data.id }
//        if let index = index {
//            doItList[index] = data
//        }
//    }
//    func removeDoItList() {
//        let index = doItList.firstIndex { $0.id == id }
//        if let index = index {
//            doItList.remove(at: index)
//        }
//    }
//

