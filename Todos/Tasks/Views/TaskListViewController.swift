//
//  TaskListViewController.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import UIKit
import Combine

class TaskListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = TaskListViewModel(dataStore: DataStoreManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupAddTaskButton()
        
        title = "Tasks"
        
        // observer to viewModel
        viewModel.$taskItems
            .sink { [weak self] taskItems in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        .store(in: &cancellables)
        
        viewModel.$status
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in

                switch status {
                case .databaseFetchOperationError:
                    self?.showAlertWithMessage("Could not fetch data from store. Please try again.")
                    
                case .databaseDeleteOperationError:
                    self?.showAlertWithMessage("Task Could not be deleted.")
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTaskItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setupTableView() {
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: TaskTableViewCell.identfier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupAddTaskButton() {
        
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        button.addTarget(self,
                         action: #selector(addTaskButtonAction),
                         for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func addTaskButtonAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        guard let editViewController = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {
            return
        }
        
        editViewController.viewModel = EditTaskViewModel()

        self.present(editViewController, animated:true, completion:nil)
    }
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identfier, for: indexPath) as? TaskTableViewCell
        
        if let task = viewModel.taskAtIndex(indexPath.row),
           let cellViewModel = TaskCellViewModel(task: task) {
            cell?.viewModel = cellViewModel
       }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        guard let editViewController = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {
            return
        }
        
        let task = viewModel.taskAtIndex(indexPath.row)
        editViewController.viewModel = EditTaskViewModel(taskToEdit: task)
        present(editViewController, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(atindex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
