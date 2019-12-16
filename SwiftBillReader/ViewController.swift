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
import Lottie


class ViewController: UIViewController {
    
    
    @IBOutlet weak var billButton: UIButton!
    @IBOutlet weak var submitJourneyButton: UIButton!
    @IBOutlet weak var animationHolderView: UIView!
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    var helper = ResultviewHelper()
    var animView = AnimationView(name: "barcodelottie")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helper = ResultviewHelper()
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
        textRecognitionRequest.usesLanguageCorrection = false
        animView.play()
        if let count = CoreDataManager.getAllData()?.count, count > 0 {
            billButton.setTitle("Add Bill", for: .normal)
            submitJourneyButton.isHidden = false
        } else {
            billButton.setTitle("Add Your First Bill", for: .normal)
            submitJourneyButton.isHidden = true
        }
    }
    @IBAction func scanReceipt(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    @IBAction func submitJourneyButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter Journey", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Journey Name"
        }
        let saveAction = UIAlertAction(title: "Submit Journey", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let text = firstTextField.text, !text.isEmpty else {
                return
            }
            if let url = CoreDataManager.saveAndExport(){
                let model = HistoryCSVModel(fileDisplayName: text, filePath: url, submitDate: Date())
                CoreDataManager.saveCSV(withModel: model)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func addBillDidTapped(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true)
    }
    
    @IBAction func historyButtonDidTapped(_ sender: Any) {
        
        let helper = HistoryHelper()
        let controller = CommonTableViewController.instantiate(dataSource: helper, delegate: helper)
        helper.controller = controller
        self.navigationController?.pushViewController(controller, animated: true)
        
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
    
    func setupAnimation() {
        animView = AnimationView(name: "barcodelottie")
        animView.loopMode = .autoReverse
        self.animationHolderView.add(subView: animView)
        animView.play()
    }
}



