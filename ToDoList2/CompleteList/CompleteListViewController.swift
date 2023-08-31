//
//  CompleteListViewController.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/25.
//

import UIKit

class CompleteListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
  
    var dataManager = DataManager.shared // 데이터 매니저 인스턴스 생성
    
    var completedTasks: [List] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 완료된 할 일 목록을 가져옴
        completedTasks = dataManager.getCompletedTasks()
    }
    
    
}

extension CompleteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteCell", for: indexPath) as? CompleteListTableViewCell else {
            return UITableViewCell()
        }
        
        let task = completedTasks[indexPath.row]
        
        cell.contentLabel.text = task.content
        
        return cell
    }
}
