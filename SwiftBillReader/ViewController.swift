//
//  ViewController.swift
//  SwiftBillReader
//
//  Created by Rahul Pengoria on 15/12/19.
//  Copyright © 2019 Hacker Packer. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import CommonUIKit

class ViewController: UIViewController {
    var textRecognitionRequest = VNRecognizeTextRequest()
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    let helper = ResultviewHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        self.helper.addRecognizedText(recognizedText: requestResults)
                        //self.resultsViewController?.addRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        // Do any additional setup after loading the view.
    }
    @IBAction func scanReceipt(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    @IBAction func addBillDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Full screen", style: .default, handler: { (_) in
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "MultiPart", style: .default, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @IBAction func historyButtonDidTapped(_ sender: Any) {
        
    }
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }    
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        var vcID: String?
//        switch scanMode {
//        case .receipts:
//            vcID = DocumentScanningViewController.receiptContentsIdentifier
//        case .businessCards:
//            vcID = DocumentScanningViewController.businessCardContentsIdentifier
//        default:
//            vcID = DocumentScanningViewController.otherContentsIdentifier
//        }
//
//            resultsViewController = helper as? (UIViewController & RecognizedTextDataSource)
        
        self.view.lock()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.helper.image = image
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
//                    if let resultsVC = self.resultsViewController {
                    let controller = CommonTableViewController.instantiate(dataSource: self.helper, delegate: self.helper)
                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
                    
                    self.view.unlock()
                }
            }
        }
    }
}


