//
//  ToDoListTableViewCell.swift
//  ToDoList2
//
//  Created by Lee on 2023/08/25.
//

import UIKit



class ToDoListTableViewCell: UITableViewCell {


    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var completeSwitch: UISwitch!
    
    @IBOutlet weak var contentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
