//
//  CustomButtonViewController.swift
//  Demo
//
//  Created by Ashok Kumar on 14/04/19.
//  Copyright © 2019 Ashok Kumar. All rights reserved.
//

import UIKit
import CommonUIKit

class CustomButtonViewController: UIViewController, CustomButtonDelegate, CustomAlertDelegate {
    func didTapRightButton(sender: Any, parent: Any) {
        print("right")
    }
    
    func didTapLeftButton(sender: Any, parent: Any) {
        print("right")
    }
    
    
    @IBOutlet weak var containedButton: CustomButton!
    @IBOutlet weak var outlineButton: CustomButton!
    @IBOutlet weak var ghostButton: CustomButton!
    @IBOutlet weak var disabledButton: CustomButton!
    @IBOutlet weak var containedImageButton: CustomButton!
    @IBOutlet weak var outlinedImageButton: CustomButton!
    @IBOutlet weak var ghostImageButton: CustomButton!
    @IBOutlet weak var disabledImageButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    func setupButtons() {
        containedButton.setButton(withTitle: "Contained Button", image: nil, type: .contained)
        containedButton.tag = 0
        outlineButton.setButton(withTitle: "Outlined Button", image: nil, type: .outlined)
        outlineButton.tag = 1
        ghostButton.setButton(withTitle: "Ghost Button", image: nil, type: .ghost)
        ghostButton.tag = 2
        disabledButton.setButton(withTitle: "Disabled Button", image: nil, type: .disabled)
        
        containedImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .contained)
        containedImageButton.tag = 3
        outlinedImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .outlined)
        outlinedImageButton.tag = 4
        ghostImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .ghost)
        disabledImageButton.setButton(withTitle: nil, image: #imageLiteral(resourceName: "bag"), type: .disabled)
        
        containedButton.delegate = self
        outlineButton.delegate = self
        ghostButton.delegate = self
        containedImageButton.delegate = self
    }

    func didTapButton(sender: Any) {
        
        let alert = CustomAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.rightButtonAction = { (sender) in
            print("right")
        }
        alert.leftButtonAction = { (sender) in
            print("left")
        }
        alert.delegate = self
        
        if let sender_ = sender as? CustomButton {
            
            switch sender_.tag {
            case 0:
                alert.createAlert(attributedTitle: NSAttributedString(string: "Prominent Title Goes Here?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]), attributedDescription: NSAttributedString(string: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green]), attributedRightButtonTitle: NSAttributedString(string: "Click Me"), attributedLeftButtonTitle: nil, alertType: .info, shouldAutoDismiss: false, buttonType: .outlined)
            case 1:
                
                let details = customBuilder()
                
                alert.createAlert(with: details)
                alert.closeButtonAction = { _ in
                    alert.dismiss(animated: false, completion: nil)
                }

            case 2:
                alert.createAlert(title: "Prominent Title Goes Here?", description: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", rightButtonTitle: "Click Me", leftButtonTitle: "Ok", alertType: .success)
            case 3:
                alert.createAlert(title: "Prominent Title Goes Here?", description: "Your catchy description goes here.  Williamsburg truffaut af messenger bag fixie schlitz put a bird on it. Palo santo microdosing lyft.", rightButtonTitle: "Click Me", leftButtonTitle: "Simple Action", alertType: .error)
            default:
                break
            }
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func customBuilder() -> AlertBuilder {
        
        let alert = AlertBuilder(build: {
            
            let stackview = UIStackView()
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            titleLabel.attributedText = NSMutableAttributedString.init(string: "Yeay, You Receive Points!", attributes: [NSAttributedString.Key.font : UIFont.init(name: "EffraMedium-Regular", size: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.87)])
            
            let descriptionLabel = UILabel()
            descriptionLabel.numberOfLines = 0
            descriptionLabel.attributedText = NSMutableAttributedString.init(string: "You completed phone number verification and scored 400 Blibli Reward points!", attributes: [NSAttributedString.Key.font : UIFont.init(name: "Effra-Regular", size: 14) as Any, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.38)])
            
            let bubble = CustomBubble()
            bubble.borderWidth = 2.0
            var rect = bubble.frame
            rect.size.width = 150.0
            bubble.frame = rect
            bubble.borderColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
            bubble.setMainButtonTitle("+ 400 Points!", titleColor: UIColor(red: 0, green: 178.0/255.0, blue: 90.0/255.0, alpha: 1.0))
            stackview.addArrangedSubview(titleLabel)
            stackview.addArrangedSubview(bubble)
            stackview.addArrangedSubview(descriptionLabel)
            
            $0.image = UIImage(named: "DLS-PNV_Success")
            $0.imagePosition = .center
            $0.stackView = stackview
            $0.rightButtonTitle = "OK"
            $0.leftButtonTitle = "Cancel"
            $0.buttonType = .contained
            $0.buttonPosition = .right
            $0.alertType = .custom
            $0.shouldShowCloseButton = true
        })
        
        return alert
    }
}
