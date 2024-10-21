//
//  File.swift
//  App
//
//  Created by Winky51 on 19.10.2024.
//

import Foundation
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    
    
    // MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

    private init() {}
    
    // MARK: - Core Data Saving support
    private func contextView() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = contextView()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTask(completion: (Result<[TaskObject],Error>)-> Void) {
        let request = TaskObject.fetchRequest()
        do {
            let data = try contextView().fetch(request)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func add(object: String, completion: (TaskObject) -> Void) {
        let data = TaskObject(context: contextView())
        data.text = object
        completion(data)
        
        saveContext()
    }

    func delete(_ object: TaskObject) {
        let context = contextView()
        context.delete(object)
        
        saveContext()
    }
    
    func update(object: TaskObject, content: String) {
        object.text = content
        
        saveContext()
    }
}
