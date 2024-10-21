//
//  ViewController.swift
//  App
//
//  Created by Winky51 on 19.10.2024.
//

import UIKit
import CoreData

final class TaskViewController: UITableViewController {
    
    private let cellId = "Cell"
    private let storageManager = StorageManager.shared
    private var tasks: [TaskObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        fetchData()
    }

    @objc private func addContent() {
        showAlert()
       
    }
    
    private func showAlert( _ task: TaskObject? = nil, completion: (() -> Void)? = nil) {
        let factory = AlertFactory(
            action: task != nil ? .update : .add,
            taskText: task?.text
            )
            let alert = factory.createAlert {[unowned self] taskText in
                guard !taskText.isEmpty else { return }
                if let task, let completion {
                    print("update \(task)")
                    storageManager.update(object: task, content: taskText)
                    completion()
                } else {
                    print("Added \(taskText)")
                    storageManager.add(object: taskText){taskObject in
                        tasks.append(taskObject)
                        let indexPath = [IndexPath(row: tasks.count - 1, section: 0)]
                        tableView.insertRows(at: indexPath, with: .automatic)
                    }
                }
                
            }
        present(alert, animated: true)
        
        
    }
    
    private func fetchData() {
        storageManager.fetchTask { result in
            switch result {
                case .success(let tasksData):
                    tasks = tasksData
                case .failure(let error):
                    print(error)
            }
        }
    }
}

extension TaskViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .abBackgroundCell
        cell.layer.cornerRadius = 5
        cell.selectionStyle = .blue
        var config = cell.defaultContentConfiguration()
        config.text = text.text
        
        cell.contentConfiguration = config
        
        return cell
    }
    
}

//MARK: UITableViewDelegate
extension TaskViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = tasks[indexPath.row]
        if editingStyle == .delete {
            storageManager.delete(object)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = tasks[indexPath.row]
        print(indexPath)
        showAlert(object){
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: Setup UI
private extension TaskViewController {
    func setupNavigationBar() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.backgroundColor = .abBackgroundThem
        
        
        title = " App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let nawBarConfig = UINavigationBarAppearance()
        nawBarConfig.configureWithOpaqueBackground()
        nawBarConfig.backgroundColor = .abThem
        
        nawBarConfig.titleTextAttributes = [.foregroundColor: UIColor.white]
        nawBarConfig.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = nawBarConfig
        navigationController?.navigationBar.scrollEdgeAppearance = nawBarConfig
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addContent)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

