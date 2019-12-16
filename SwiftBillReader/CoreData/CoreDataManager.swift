//
//  CoreDataManager.swift
//  CoreDataExample
//
//  Created by Ravi Tripathi on 13/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static func save(data: DataModel) {
        guard let managedContext =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
        }
        let expense =
            NSEntityDescription.entity(forEntityName: "Expense",
                                       in: managedContext)!
        let dataUnit = NSManagedObject(entity: expense,
                                       insertInto: managedContext)
        
        dataUnit.setValue(data.category, forKeyPath: "category")
        dataUnit.setValue(data.date, forKeyPath: "date")
        dataUnit.setValue(data.desc, forKey: "desc")
        dataUnit.setValue(data.image, forKey: "image")
        dataUnit.setValue(data.total, forKey: "total")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func getAllData() -> [DataModel]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Expense")
        do {
            let items = try managedContext.fetch(fetchRequest)
            
            var modelArray = [DataModel]()
            for item in items {
                let category = item.value(forKey: "category") as? String
                let date = item.value(forKey: "date") as? Date
                let desc = item.value(forKey: "desc") as? String
                let total = item.value(forKey: "total") as? Double
                let image = item.value(forKey: "image") as? Data
                
                let model = DataModel(category: category, date: date, desc: desc, total: total, image: image)
                modelArray.append(model)
            }
            return modelArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //    static func convertToJSONArray(moArray: [NSManagedObject]) -> Data? {
    //        var jsonArray: [[String: Any]] = []
    //        for item in moArray {
    //            var dict: [String: Any] = [:]
    //            for attribute in item.entity.attributesByName {
    //                //check if value is present, then add key to dictionary so as to avoid the nil value crash
    //                if let value = item.value(forKey: attribute.key) {
    //                    dict[attribute.key] = value
    //                }
    //            }
    //            jsonArray.append(dict)
    //        }
    //        return (try? JSONSerialization.data(withJSONObject: jsonArray))
    //    }
    
    static func saveAndExport() -> URL? {
        
        guard let data: [DataModel] = CoreDataManager.getAllData() else {
            return nil
        }
        
        var exportString: String = NSLocalizedString("Bill Number, Date, Category, Total, Description\n", comment: "")
        for (index, item) in data.enumerated() {
            //Index is the bill number
            guard let date = item.date, let category = item.category, let total = item.total else {
                continue
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            exportString += "\(index+1),\(formatter.string(from: date)),\(category),\(total),\(item.desc ?? "") \n"
        }
        
        let exportFilePath = NSTemporaryDirectory() + "itemlist.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            return URL(fileURLWithPath: exportFilePath)
        }
        return nil
    }
    
    static func clearAll() {
        guard let context =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
        }
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}


extension CoreDataManager {
    
    static func saveCSV(withModel model: HistoryCSVModel) {
        guard let context =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
        }
        CoreDataManager.clearAll()
        let expense =
            NSEntityDescription.entity(forEntityName: "History",
                                       in: context)!
        let dataUnit = NSManagedObject(entity: expense,
                                       insertInto: context)
        dataUnit.setValue(model.fileDisplayName, forKeyPath: "fileDisplayName")
        dataUnit.setValue(model.filePath, forKeyPath: "filePath")
        dataUnit.setValue(model.submitDate, forKeyPath: "submitDate")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func getAllCSVHistory() -> [HistoryCSVModel]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "History")
        do {
            let items = try managedContext.fetch(fetchRequest)
            
            var modelArray = [HistoryCSVModel]()
            for item in items {
                let fileDisplayName = item.value(forKey: "fileDisplayName") as? String
                
                let filePath = item.value(forKey: "filePath") as? URL
                let submitDate = item.value(forKey: "submitDate") as? Date
                
                let model = HistoryCSVModel(fileDisplayName: fileDisplayName, filePath: filePath, submitDate: submitDate)
                modelArray.append(model)
            }
            return modelArray
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
