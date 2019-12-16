//
//  QLPreviewItemHelper.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 16/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import QuickLook

class MYQLPreviewController : QLPreviewController, QLPreviewControllerDataSource {
    
    var priviewItem: URL?
     //var fileURL: URL?
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        self.priviewItem as! QLPreviewItem
    }
    
    func openDocument(vc: UIViewController, url: URL?) {
        

        guard let document = url else {
            print("Cannot open document because it's nil")
            return
        }
        if let navController = vc.navigationController {
            navController.pushViewController(self, animated: true)
        } else {
            vc.show(self, sender: nil)
        }
//        print(self.priviewItem)
//        self.dataSource = self
//        self.reloadData()
        if QLPreviewController.canPreview(document as QLPreviewItem) {
            self.currentPreviewItemIndex = 0
            self.priviewItem = document
            self.dataSource = self
            self.reloadData()

        }
        

//        API.sharedInstance.fetchDocument(document) { (saved) in
//            DispatchQueue.main.async(execute: {
//                guard let url = saved else {
//                    print("File url is not valid")
//                    return
//                }
//                if QLPreviewController.canPreview(url as QLPreviewItem) {
//                    self.currentPreviewItemIndex = 0
//                    self.fileURL = url
//                    self.dataSource = self
//                    self.delegate = self
//                    self.reloadData()
//
//                } else {
//                    makeDefaultAlert(self, title: "Not supported", msg: "File is not supported for preview")
//                    print("Item not supported by QLPreviewController")
//                }
//            })
//        }
    }
    
//    func show(controller: UIViewController, data: QLPreviewItemHelper) {
//        self.priviewItem = data.priviewItem
//        self.dataSource = data
//        // Refreshing the view
//        self.reloadData()
//        // Printing the doc
//        if let navController = controller.navigationController {
//            navController.pushViewController(self, animated: true)
//        }
//        else {
//            controller.show(self, sender: nil)
//        }
//    }
    
     override func viewDidLayoutSubviews() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [shareButton]
    }
    
    @objc private func share(){
        let activityItems = [UIImage(named: "back"), UIImage(named: "back")] as [Any]
        let applicationActivities: [UIActivity]? = nil
        let excludeActivities = [UIActivity.ActivityType.assignToContact,
                                 UIActivity.ActivityType.copyToPasteboard,
                                 UIActivity.ActivityType.postToWeibo,
                                 UIActivity.ActivityType.print,
                                 UIActivity.ActivityType.message]
        
        let activityController = UIActivityViewController.init(activityItems: activityItems, applicationActivities: applicationActivities)
        activityController.excludedActivityTypes = excludeActivities
        activityController.setValue("PFA Bills", forKey: "subject")
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
    }
}

class QLPreviewItemHelper: QLPreviewControllerDataSource {
    lazy var priviewItem = NSURL()
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        self.priviewItem as QLPreviewItem
    }
    
}
