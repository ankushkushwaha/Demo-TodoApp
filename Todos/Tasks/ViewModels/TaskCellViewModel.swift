//
//  TaskCellViewModel.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import Foundation
import UIKit

class TaskCellViewModel {
    
    let title: String
    var subTitle:String?
    let dueDate: String
    let isComplete: Bool
    var backGroundColor: UIColor = .clear
    var accessoryType: UITableViewCell.AccessoryType = .none

    init?(task: TaskEntity) {
        guard let name = task.name else {
            return nil
        }
        
        title = name
        dueDate = task.dueDate?.string ?? ""
        isComplete = task.isComplete
        
        subTitle = task.taskDescription

        if let text = task.taskDescription, text.count > 0 {
            subTitle = "\(text)\n\nDue date: \(dueDate)"

        } else {
            subTitle = "Due date: \(dueDate)"
        }
        
        backGroundColor = .clear
        accessoryType = .none

        if isComplete {
            backGroundColor = backgroundColorForCompletedTask
            accessoryType = .checkmark
        }
    }
    
    var backgroundColorForCompletedTask: UIColor {
        UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
    }
}
