//
//  HistoryHelper.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import CommonUIKit
import QuickLook

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
    
    func navigationBarColor() -> UIColor? {
        return .lightGray
    }
    
    func customBackButton() -> UIImage? {
        return UIImage(named: "back")
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["CommonUIKit.CustomTextField"]
    }
    
    func reusableIdentifiersForSimpleTableViewCell() -> [String]? {
        return ["Cell"]
    }
    
    func navigationTitle() -> String {
        return "Billing History"
    }
    
    func shouldShowSeparatorLine() -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showcsvFile(filePath: list[indexPath.row].filePath ?? nil)
    }
    
    func showcsvFile(filePath: URL?) {
        if let url = filePath {
            let docpreview = MYQLPreviewController()
            docpreview.openDocument(vc: self.controller!, url: url)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonUIKit.CustomTextField", for: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomTextField else {
             return UITableViewCell()
         }
         customView.backgroundColor = .white
         customView.isUserInteractionEnabled = false
        if let name = list[indexPath.row].fileDisplayName {
            customView.textFieldText = NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
         customView.placeholderText = NSAttributedString(string: self.getDateString(date: list[indexPath.row].submitDate ?? Date()), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
         customView.layer.cornerRadius = 8
         cell.setCard(horizontalOffset: 16, verticalOffset: 8)
         return cell
    }
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: date)
    }
    

}
