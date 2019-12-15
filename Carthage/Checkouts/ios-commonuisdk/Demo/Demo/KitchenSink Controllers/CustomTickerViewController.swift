//
//  CustomTickerViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomTickerViewController: UIViewController {

    @IBOutlet weak var successTicker: CustomTicker!
    @IBOutlet weak var warningTicker: CustomTicker!
    @IBOutlet weak var infoTicker: CustomTicker!
    @IBOutlet weak var errorTicker: CustomTicker!
    @IBOutlet weak var defaultTicker: CustomTicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTicker()
    }
    
    func setupTicker() {
        
        successTicker.tickerType = .success
        successTicker.setLeftButtonImage(withImageName: "correct", imageColor: UIColor(hexString: "#abd673"))
        successTicker.setTitle(title: "Title Goes Here")
        successTicker.setDescription(description: "Type your content here and should be 1 lines with no links.")
        
        warningTicker.tickerType = .warning
        warningTicker.setLeftButtonImage(withImageName: "warning", imageColor: UIColor(hexString: "#eda654"))
        warningTicker.setDescription(description: "Your content type here and should be 2 lines no links.")
        
        infoTicker.tickerType = .info
        infoTicker.setLeftButtonImage(withImageName: "info", imageColor: UIColor(hexString: "#65c1f9"))
        infoTicker.setDescription(description: "Your content type here and should be 2 lines no links.")
        
        errorTicker.tickerType = .error
        errorTicker.setLeftButtonImage(withImageName: "error", imageColor: UIColor(hexString: "#dd4b49"))
        errorTicker.setRightButtonImage(withImageName: "close", imageColor: UIColor.darkGray)
        errorTicker.setDescription(description: "Your content type here and should be 2 lines no links.")
        
        defaultTicker.setDescription(description: "Your content type here and should be 2 lines no links.")
 
    }

}
