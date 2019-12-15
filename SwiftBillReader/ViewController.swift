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

class ViewController: UIViewController {
    var textRecognitionRequest = VNRecognizeTextRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                var transcript = ""
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        let maximumCandidates = 1
                        for observation in requestResults {
                            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                            transcript += candidate.string
                            transcript += "\n"
                        }
                        print(transcript)
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
//        if let vcID = vcID {
//            resultsViewController = storyboard?.instantiateViewController(withIdentifier: vcID) as? (UIViewController & RecognizedTextDataSource)
//        }
        
        self.view.lock()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    //push view controller
                    
                    self.view.unlock()
                }
            }
        }
    }
}

extension UIView {
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

