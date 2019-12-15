//
//  DateSelectionHelper.swift
//  SwiftBillReader
//
//  Created by Umesh Nagar on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import CommonUIKit

protocol DateSelectionHelperDelegate {
    func selected(dateString: String)
    func selected(categoryString: String)
}

class DateSelectionHelper: NSObject, CommonDelegateAndDataSource {
    var controller: CommonTableViewController?
    var dateArray = [Date]()
    var delegate: DateSelectionHelperDelegate?
    var categoryArray: [String]?
    
    func navigationBarColor() -> UIColor? {
        return .lightGray
    }
    
    func backgroundColorForTableView() -> UIColor? {
        return .systemGroupedBackground
    }
    
    func reusableIdentifiers() -> [String]? {
        return ["CommonUIKit.CustomTextField"]
    }
    
    func shouldShowSeparatorLine() -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryArray = categoryArray {
            return categoryArray.count
        }
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonUIKit.CustomTextField", for: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomTextField else {
            return UITableViewCell()
        }
        customView.backgroundColor = .white
        customView.isUserInteractionEnabled = false
        if let categoryArray = categoryArray {
            customView.textFieldText = NSAttributedString(string: categoryArray[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            customView.textFieldText = NSAttributedString(string: formatter.string(from: self.dateArray[indexPath.row]), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
       
        customView.placeholderText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
        cell.setCard(horizontalOffset: 16, verticalOffset: 8)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categoryArray = categoryArray {
            delegate?.selected(categoryString: categoryArray[indexPath.row])
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            delegate?.selected(dateString: formatter.string(from: self.dateArray[indexPath.row]))
        }
        self.controller?.navigationController?.popViewController(animated: true)
    }
    
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonTableViewController, otherInfo: [String : Any]?) {
        if event == .didLoad {
            controller = viewController
            viewController.reloadData()
        }
    }

}
