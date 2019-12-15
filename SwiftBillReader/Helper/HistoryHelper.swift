//
//  HistoryHelper.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import CommonUIKit

class HistoryHelper: NSObject, CommonDelegateAndDataSource {
    var controller: CommonTableViewController?
    var list = [HistoryCSVModel]()
    
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonTableViewController, otherInfo: [String : Any]?) {
        if event == .didLoad {
            if let values = CoreDataManager.getAllCSVHistory(), values.count > 0 {
                list = values
            } else {
                let alertController = UIAlertController(title: "No Bills Found", message: "", preferredStyle: .alert)
               
                let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                    self.controller?.navigationController?.popToRootViewController(animated: true)
                })

                alertController.addAction(saveAction)
                self.controller?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func customBackButton() -> UIImage? {
        return UIImage(named: "back")
    }
    
    func reusableIdentifiersForSimpleTableViewCell() -> [String]? {
        return ["Cell"]
    }
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor.systemGroupedBackground
        cell.selectionStyle = .none
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.textLabel?.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
        cell.imageView?.contentMode = .scaleAspectFit
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)

        cell.textLabel?.text = list[indexPath.row].fileDisplayName
        
        cell.detailTextLabel?.text = self.getDateString(date: list[indexPath.row].submitDate ?? Date())

        return cell ?? UITableViewCell()
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: date)
    }
    

}
