//
//  AlertFactory.swift
//  App
//
//  Created by Winky51 on 20.10.2024.
//

import Foundation
import UIKit

enum UserAction{
    case add
    case update
    
    var title: String{
        switch self {
            case .add: "Добавить запись"
            case .update: "Изменение записи"
        }
    }
        
        var message: String{
            switch self {
                case .add: "Введите текст и нажмите сохранить."
                case .update: "Внесите изменения и сохраните."
            }
        }
        
        
}

final class AlertFactory {

    let taskText: String?
    let userAction: UserAction
    
    init(action: UserAction, taskText: String? = nil) {
        self.taskText = taskText
        switch action {
            case .add:
                userAction = .add
            case .update:
                userAction = .update
        }
        
    }
    
    
    func createAlert(completion: @escaping ((String) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: userAction.title, message: userAction.message, preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            guard !text.isEmpty else { return }
            completion(text)
            
        }
        let doneButton = UIAlertAction(title: "Done", style: .destructive)
        
        alert.addAction(doneButton)
        alert.addAction(saveButton)
        alert.addTextField {[unowned self] textFueld in
            textFueld.placeholder = "Text"
            if taskText != nil {
                textFueld.text = taskText
            }
        }
        return alert
    }
        
        
        
    
}
