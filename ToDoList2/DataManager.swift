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
    
    private let doItListKey = "doItList"
    
    private var selectedCategory: Category? = nil
    
    // 데이터 생성
    func createDoItList(title: String, date: Date, content: String, isCompleted: Bool, category: Category) {
        let newDoIt = List(title: title, date: date, content: content, iscompleted: isCompleted, category: category)
        doItList.append(newDoIt)
        saveDoItListToUserDefaults()
    }
    
    // 데이터 저장
    func saveDoItListToUserDefaults() {
        let encodedData = try? JSONEncoder().encode(doItList)
        UserDefaults.standard.set(encodedData, forKey: doItListKey)
    }
    
    // 데이터 로드
    func loadDoItList() {
        if let encodedData = UserDefaults.standard.data(forKey: doItListKey),
           let savedDoItList = try? JSONDecoder().decode([List].self, from: encodedData) {
            doItList = savedDoItList
        }
    }
    
    // 데이터 삭제
    func deleteDoItList(_ task: List) {
        if let index = doItList.firstIndex(where: { $0.id == task.id }) {
            doItList.remove(at: index)
            saveDoItListToUserDefaults()
        }
    }
    // 데이터 수정
    func updateDoItList(_ task: List, title: String, date: Date, content: String, isCompleted: Bool, category: Category) {
        guard let index = doItList.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        var updatedList = doItList

        let updatedDoIt = List(id: task.id, title: title, date: date, content: content, iscompleted: isCompleted, category: category)
        updatedList[index] = updatedDoIt

        doItList = updatedList
        saveDoItListToUserDefaults()
    }
    
    
    // 선택된 카테고리 설정
    func setSelectedCategory(_ category: Category?) {
        selectedCategory = category
    }
    
    // 오늘의 할 일 목록 가져오기
    func getTodayDoItList(for category: Category) -> [List] {
        let date = Date()
        let filteredList = doItList.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date) && $0.category == category
        }.sorted {
            $0.date < $1.date
        }
        return filteredList
    }
    
    func getCompletedTasks() -> [List] {
        return doItList.filter { $0.iscompleted }
    }
    
}
