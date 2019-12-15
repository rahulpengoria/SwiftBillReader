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
    
    func lock() {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.tag = 109870
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.center = self.center
        self.addSubview(spinner)
        spinner.startAnimating()
        self.isUserInteractionEnabled = false
    }
    
    func unlock() {
        if let spinner = self.superview?.viewWithTag(109870) as? UIActivityIndicatorView{
            spinner.stopAnimating()
            self.isUserInteractionEnabled = true
            spinner.removeFromSuperview()
        }
        
    }
}
