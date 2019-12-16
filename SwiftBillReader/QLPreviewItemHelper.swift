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
    var imagesArray = [UIImage]()
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        self.priviewItem as! QLPreviewItem
    }
    
    func openDocument(vc: UIViewController, url: URL?, images: [UIImage]) {
        
        guard let document = url else {
            print("Cannot open document because it's nil")
            return
        }
        if let navController = vc.navigationController {
            navController.pushViewController(self, animated: true)
        } else {
            vc.show(self, sender: nil)
        }

        if QLPreviewController.canPreview(document as QLPreviewItem) {
            self.currentPreviewItemIndex = 0
            self.priviewItem = document
            self.imagesArray = images
            self.dataSource = self
            self.reloadData()

        }
    }
    
     override func viewDidLayoutSubviews() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [shareButton]
    }
    
    @objc private func share(){
        var activityItems = [priviewItem] as [Any]
        activityItems.append(contentsOf: imagesArray)
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
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.navigationController?.popToRootViewController(animated: true)
        }
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
