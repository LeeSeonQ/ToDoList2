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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show initial UI state
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

        ToDoImage.image = UIImage(named: "ToDo")
        showToDoList.isHidden = false
        showCompleteList.isHidden = false
        titleLabelUI()
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
}



