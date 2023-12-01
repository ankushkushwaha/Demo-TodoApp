//
//  EditViewController.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import UIKit
import Combine

class EditViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var completionSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var viewModel: EditTaskViewModel?
    
    private var cancellables = Set<AnyCancellable>()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // observer to viewModel
        viewModel?.$status
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
                
                switch status {
                case .taskCreated:
                    self?.showAlertWithMessage("Task created successfully.")
                    
                case .taskUpdated:
                    self?.showAlertWithMessage("Task updated successfully.")
                    
                case .validationError:
                    self?.showAlertWithMessage("Please enter a valid name for task.")
                case .databaseOperationError:
                    self?.showAlertWithMessage("Operation failed. Please try again later.")
                }
            })
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        if let taskToEdit = viewModel?.taskToEdit {
            continueButton.setTitle("Update Task", for: .normal)
            
            nameTextField.text = taskToEdit.name
            descriptionTextField.text = taskToEdit.taskDescription
            completionSwitch.isOn = taskToEdit.isComplete
            
            if let dueDate = viewModel?.taskToEdit?.dueDate {
                datePicker.setDate(dueDate, animated: false)
            }
        } else {
            continueButton.setTitle("Add Task", for: .normal)
            completionSwitch.isOn = viewModel?.taskToEdit?.isComplete ?? false
        }
    }
    
    @IBAction func dismissViewContoller(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addTaskButtonAction(_ sender: UIButton) {
        
        if viewModel?.taskToEdit != nil {
            viewModel?.updateTask(name: nameTextField.text,
                                 description: descriptionTextField.text,
                                 dueDate: datePicker.date,
                                 isComplete: completionSwitch.isOn)
        } else {
            viewModel?.addTask(name: nameTextField.text ?? "",
                              description: descriptionTextField.text,
                              date: datePicker.date,
                              isComplete: completionSwitch.isOn)
        }
    }
        
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            
            guard let self else {
                return
            }
            switch self.viewModel?.status {
            case .taskCreated, .taskUpdated:
                self.dismiss(animated: true)
            default:
                break
            }
        }))
        self.present(alert, animated: true)
    }
}


extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
