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
    
    func navigationBarColor() -> UIColor? {
        return .blue
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonUIKit.CustomTextField", for: indexPath) as? BaseTableViewCell, let customView = cell.customView as? CustomTextField else {
            return UITableViewCell()
        }
        if indexPath.row == 0, let date = receiptItem?.date {
            customView.textFieldText = NSAttributedString(string: date, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            customView.placeholderText = NSAttributedString(string: "Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
        } else if indexPath.row == 1, let total = receiptItem?.total {
            customView.textFieldText = NSAttributedString(string: "\(total)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            customView.placeholderText = NSAttributedString(string: "Total amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0095da")])
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
    
    func getDateStringFrom(string: String) -> String {
        var dateString = ""
        let pattern = "(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.]([0-9]+)"
        let pattern2 = "(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.]([0-9]+)"
        let pattern3 = "([0-9]+)[- /.](0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])"
        let pattern4 = "(0[1-9]|[12][0-9]|3[01])[- /.]([a-z A-Z]+)[- /.]([0-9]+)"
        let pattern5 = "([a-z A-Z]+)[- /.](0[1-9]|[12][0-9]|3[01])[- /.]([0-9]+)"
        let pattern6 = "(20[0-9]+)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])"
        
        let expression = try! NSRegularExpression.init(pattern: pattern, options: .caseInsensitive)
        let expression2 = try! NSRegularExpression.init(pattern: pattern2, options: .caseInsensitive)
        let expression3 = try! NSRegularExpression.init(pattern: pattern3, options: .caseInsensitive)
        let expression4 = try! NSRegularExpression.init(pattern: pattern4, options: .caseInsensitive)
        let expression5 = try! NSRegularExpression.init(pattern: pattern5, options: .caseInsensitive)
        let expression6 = try! NSRegularExpression.init(pattern: pattern6, options: .caseInsensitive)
        
        if let result = expression5.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        } else if let result = expression4.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        } else if let result = expression3.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        } else if let result = expression6.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        } else if let result = expression2.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        } else if let result = expression.firstMatch(in: string, options: [], range: NSRange.init(location: 0, length: string.count)) {
            dateString = (string as NSString).substring(with: result.range)
        }
        return dateString
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

}


// MARK: RecognizedTextDataSource
extension ResultviewHelper: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        // Create a full transcript to run analysis on.
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            transcript += candidate.string
            transcript += "\n"
        }
    }
}
