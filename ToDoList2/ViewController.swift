//
//  ViewController.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/24.
//

import UIKit

class ViewController: UIViewController {



    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var showToDoList: UIButton!
    
    @IBOutlet weak var showCompleteList: UIButton!
    
    @IBOutlet weak var ToDoImage: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경 이미지 설정
        ToDoImage.image = UIImage(named: "40")
        ToDoImage.contentMode = .scaleAspectFill
        
        loadImageFromURL()
        

//               // 배경화면 애니메이션
//               UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
//                   self.ToDoImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//               }) { _ in
//                   UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                       self.ToDoImage.transform = .identity
//                   })
//               }
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show initial UI state
        setupUI()
        animateInitialUIState()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Disable animations when transitioning to another screen
            UIView.setAnimationsEnabled(false)
        }
        
    private func titleLabelUI() {
        titleLabel.textAlignment = .center
        let boldFont = UIFont.boldSystemFont(ofSize: 35.0)
        let attributedString = NSAttributedString(string: "ToDoList!", attributes: [NSAttributedString.Key.font: boldFont])
        titleLabel.attributedText = attributedString
        titleLabel.text = "ToDoList!"
    }
    
    private func setupUI() {

        toDoImageSet()
        showToDoList.isHidden = false
        showCompleteList.isHidden = false
        titleLabelUI()
    }
    
    func toDoImageSet() {
        let originalImage = UIImage(named: "40")
        let imageSize = CGSize(width: 250, height: 250) // 원하는 크기로 설정
        
        if let resizedImage = originalImage?.resize(to: imageSize) {
            ToDoImage.image = resizedImage
        }
    }
    
    private func animateImageAppearance() {
        // 이미지의 초기 크기를 설정합니다.
        ToDoImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        // 이미지를 애니메이션과 함께 원래 크기로 돌려놓습니다.
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.ToDoImage.transform = .identity
        })
    }
    
    
    private func animateInitialUIState() {
        // Animate the appearance of UI elements
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLabel.alpha = 1
            self.ToDoImage.alpha = 1
        }) { _ in
            // After labels and image have appeared, animate buttons
            self.showToDoList.transform = CGAffineTransform(translationX: 0, y: 400)
            self.showCompleteList.transform = CGAffineTransform(translationX: 0, y: 300)
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                self.showToDoList.alpha = 1
                self.showCompleteList.alpha = 1
                self.showToDoList.transform = .identity
                self.showCompleteList.transform = .identity
            })
        }
    }
    
    func loadImageFromURL() {
        let imageUrlString = "https://spartacodingclub.kr/css/images/scc-og.jpg"
        
        // 이미지 URL을 기반으로 URL 객체 생성
        if let imageUrl = URL(string: imageUrlString) {
            // 백그라운드 스레드에서 이미지를 가져와서 메인 스레드에서 UI 업데이트
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData)
                    
                    // 메인 스레드에서 UI 업데이트
                    DispatchQueue.main.async {
                        // 이미지를 imageView에 설정
                        self.imageView.image = image
                        
                    
                        
                    }
                }
            }
        }
    }
}


extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
