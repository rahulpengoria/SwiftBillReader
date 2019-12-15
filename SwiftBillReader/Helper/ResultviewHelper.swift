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


class ResultviewHelper: UIViewController {
    var textView: UITextView?
    var transcript = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView = UITextView()
        
        self.view.add(subView: textView!)
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
        textView?.text = transcript
    }
}
