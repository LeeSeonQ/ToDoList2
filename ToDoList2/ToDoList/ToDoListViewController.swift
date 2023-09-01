//
//  ToDoListViewController.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/25.
//

import UIKit



class ToDoListViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let dataManager = DataManager.shared // 데이터 매니저 인스턴스 생성
    
    var selectedCategory: Category? // 선택된 카테고리를 저장하는 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // 전체 헤더뷰 생성 및 설정
               let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
               headerView.backgroundColor = UIColor.blue
               let headerLabel = UILabel(frame: headerView.bounds)
               headerLabel.textAlignment = .center
               headerLabel.textColor = UIColor.white
               headerLabel.text = "머리"
               headerView.addSubview(headerLabel)
               tableView.tableHeaderView = headerView
               
               // 전체 푸터뷰 생성 및 설정
               let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
               footerView.backgroundColor = UIColor.red
               let footerLabel = UILabel(frame: footerView.bounds)
               footerLabel.textAlignment = .center
               footerLabel.textColor = UIColor.white
               footerLabel.text = "발"
               footerView.addSubview(footerLabel)
               tableView.tableFooterView = footerView
               
               tableView.delegate = self
               tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이터 로드 및 테이블뷰 업데이트
        dataManager.loadDoItList()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 다른 화면으로 네비게이션하기 전에 데이터 저장
        dataManager.saveDoItListToUserDefaults()
    }
    
    @IBAction func listAddButton(_ sender: Any) {
        let categoryAlert = UIAlertController(title: "카테고리 선택", message: nil, preferredStyle: .alert)
        let categories: [Category] = [.none, .work, .life]
        
        for category in categories {
            categoryAlert.addAction(UIAlertAction(title: category.rawValue, style: .default) { _ in
                self.presentAddTaskAlert(for: category)
            })
        }
        
        categoryAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(categoryAlert, animated: true, completion: nil)
    }
    
    private func presentAddTaskAlert(for category: Category) {
        let alert = UIAlertController(title: "할 일 추가", message: "내용을 입력하세요.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "내용"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            if let content = alert.textFields?.first?.text {
                DataManager.shared.createDoItList(title: content, date: Date(), content: content, isCompleted: false, category: category)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
 

}
    

extension ToDoListViewController: UITableViewDelegate,UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
           return Category.allCases.count
       }

       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return Category.allCases[section].rawValue
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let category = Category.allCases[section]
           return dataManager.getTodayDoItList(for: category).count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoListTableViewCell else {
            return UITableViewCell()
        }

        let category = Category.allCases[indexPath.section]
        let todayDoItList = dataManager.getTodayDoItList(for: category)
        let task = todayDoItList[indexPath.row]

        cell.contentLabel.text = task.content
        cell.completeSwitch.isOn = task.iscompleted

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd" // 원하는 날짜 포맷으로 변경
        let dateString = dateFormatter.string(from: task.date)
        cell.dateLabel.text = dateString

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = Category.allCases[indexPath.section]
        let todayDoItList = dataManager.getTodayDoItList(for: selectedCategory)
        let task = todayDoItList[indexPath.row]
        
        let alert = UIAlertController(title: "작업 선택", message: "원하는 동작을 선택하세요", preferredStyle: .actionSheet)
        
        let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
            let alertController = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "새로운 내용"
                textField.text = task.content // 기존 내용을 보여줌
            }
            
            let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
                if let newContent = alertController.textFields?.last?.text {
                    let currentDate = Date()
                    
                    self.dataManager.updateDoItList(task, title: task.title!, date: currentDate, content: newContent, isCompleted: task.iscompleted, category: task.category)
                    self.tableView.reloadData()
                }
            }
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.dataManager.deleteDoItList(task)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alertController.addAction(saveAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        tableView.deselectRow(at: indexPath, animated: true)
        present(alert, animated: true, completion: nil)
    }
    
    // 섹션의 헤더 뷰 반환
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = UIColor.lightGray // 헤더 배경색 설정
          
          let headerLabel = UILabel()
          headerLabel.frame = CGRect(x: 15, y: 5, width: tableView.frame.size.width - 30, height: 30)
          headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
          headerLabel.textColor = UIColor.black
          headerLabel.text = Category.allCases[section].rawValue // 섹션별 카테고리명 설정
          
          headerView.addSubview(headerLabel)
          return headerView
      }
      
      // 섹션의 푸터 뷰 반환
      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          let footerView = UIView()
          let footerLabel = UILabel()
          
          footerView.backgroundColor = UIColor.lightGray // 푸터 배경색 설정
          
          footerLabel.frame = CGRect(x: 15, y: 5, width: tableView.frame.size.width - 30, height: 30)
          footerLabel.font = UIFont.boldSystemFont(ofSize: 20)
          footerLabel.textColor = UIColor.black
          footerLabel.text = "this is footer" // 섹션별 카테고리명 설정
          footerView.addSubview(footerLabel)
          return footerView
      }
      
      // 섹션의 헤더 높이 반환
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 30 // 헤더 높이 설정
      }
      
      // 섹션의 푸터 높이 반환
      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 30 // 푸터 높이 설정
      }
    
}

