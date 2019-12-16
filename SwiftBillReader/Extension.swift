//
//  Extension.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit

extension UIView {
    func add(subView : UIView?) {
        if let subView = subView {
            self.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":subView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":subView]))
        }
    }
}
