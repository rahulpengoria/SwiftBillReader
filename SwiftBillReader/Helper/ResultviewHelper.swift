//
//  ResultviewHelper.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import Vision
import CommonUIKit


class ResultviewHelper: UIViewController, CommonDelegateAndDataSource {
    
    var receiptItem: ReceiptItem?
    var controller: CommonTableViewController?
    var transcript = ""
    var image = UIImage()
    var dateArray = [Date]()
    
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
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonUIKit.CustomTextField", for: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomTextField else {
            return UITableViewCell()
        }
        customView.backgroundColor = .white
        customView.delegate = self
        customView.isUserInteractionEnabled = false
        if indexPath.row == 0, let date = receiptItem?.date {
            customView.isUserInteractionEnabled = false
            customView.textFieldText = NSAttributedString(string: date, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            customView.placeholderText = NSAttributedString(string: "Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
        } else if indexPath.row == 1, let total = receiptItem?.total {
            customView.isUserInteractionEnabled = true
            customView.textFieldText = NSAttributedString(string: "\(total)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            customView.placeholderText = NSAttributedString(string: "Total amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
        } else if indexPath.row == 2 {
            if let category = receiptItem?.category {
                customView.textFieldText = NSAttributedString(string: category, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                customView.placeholderText = NSAttributedString(string: "Category", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
            } else {
                customView.textFieldText = NSAttributedString(string: "Select Category", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            }
            customView.isUserInteractionEnabled = false
        }
        cell.setCard(horizontalOffset: 16, verticalOffset: 8)
        return cell
    }
    
    func handleEvent(withControllerLifeCycle event: ViewControllerLifeCycleEvents, viewController: CommonTableViewController, otherInfo: [String : Any]?) {
        if event == .didLoad {
            controller = viewController
            receiptItem = ReceiptItem()
            self.receiptItem?.date = self.getDateStringFrom(string: transcript)
            self.receiptItem?.total = self.getTotalAmountFrom(string: transcript)
            viewController.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let helper = DateSelectionHelper()
            helper.delegate = self
            helper.dateArray = self.dateArray
            let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
            self.controller?.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 2 {
            let helper = DateSelectionHelper()
            helper.delegate = self
            helper.categoryArray = ["Meal", "Entertainment"]
            let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
            self.controller?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func getDateStringFrom(string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: self.dateArray.first ?? Date())
    }
    
    func getTotalAmountFrom(string: String) -> Double {
        var finalResult = 0.0
        let arrayOfStrings = string.split(separator: "\n")
        for str in arrayOfStrings {
            let string: String = String(str)
            let pattern = "((\\d+[\\. ,]\\d+))"
            let expression: NSRegularExpression = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
            if let result = expression.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
                if let doubleValue = Double((string as NSString).substring(with: result.range)),
                    doubleValue > finalResult {
                    finalResult = doubleValue
                }
            }
        }
        return finalResult
    }
    
    func getHeaderView(for viewController: CommonTableViewController) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: viewController.view.frame.height / 3))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        view.add(subView: imageView)
        return view
    }
    
    func heightForHeaderView(for viewController: CommonTableViewController) -> CGFloat {
        return viewController.view.frame.height / 3
    }
    
    func getFooterView(for viewController: CommonTableViewController) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        button.backgroundColor = .orange
        button.setTitle("Submit bill", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(actionBtnInfo(sender:)), for: .touchUpInside)
        return button
    }
    
    func heightForFooterView(for viewController: CommonTableViewController) -> CGFloat {
        return 50
    }
    
    @objc func actionBtnInfo(sender: UIButton) {
        CoreDataManager.save(data: self.createDataModel())
        self.controller?.navigationController?.popViewController(animated: true)
        print(CoreDataManager.getAllData())
    }
    
    func createDataModel() -> DataModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let date = formatter.date(from: self.receiptItem?.date ?? "") ?? Date()
        let dataModel = DataModel(category: self.receiptItem?.category ?? "", date: formatter.string(from: date), desc: self.receiptItem?.desc, total: self.receiptItem?.total ?? 0.0)
        return dataModel
    }

}

extension ResultviewHelper: DateSelectionHelperDelegate {
    func selected(dateString: String) {
        self.receiptItem?.date = dateString
        self.controller?.reloadData()
    }
    
    func selected(categoryString: String) {
        self.receiptItem?.category = categoryString
        self.controller?.reloadData()
    }
    
}

// MARK: CustomTextFieldDelegate

extension ResultviewHelper: CustomTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField, parent: Any) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, parent: Any) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField, parent: Any) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: RecognizedTextDataSource
extension ResultviewHelper: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        // Create a full transcript to run analysis on.
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            
            let text = candidate.string
            do {
                // Create an NSDataDetector to detect whether there is a date in the string.
                let types: NSTextCheckingResult.CheckingType = [.date]
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
                for match in matches {
                  if match.resultType == .date,
                    let components = match.date {
                    dateArray.append(components)
                    print(("Date", components))
                  } else {
                    print("no components found")
                  }
                }
            } catch {
                print(error)
            }
            
            transcript += candidate.string
            transcript += "\n"
        }
    }
}
