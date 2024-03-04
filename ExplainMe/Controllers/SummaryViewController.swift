//
//  SummaryViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import PDFKit
import NVActivityIndicatorView

class SummaryViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var downloadButton: UIButton!
    
    
    //MARK: VARIABLE
    var transcibe = ""
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.setCircle(View: saveButton, value: 5)
        downloadButton.setCircle(View: downloadButton, value: 5)
        
        summaryTextView.setCircle(View: summaryTextView, value: 40)
        
        loaderView.startAnimating()
        OpenAi.summary(text: transcibe) { response in
            
            self.summaryTextView.text = response as! String
            self.loaderView.stopAnimating()
        }
        
        
    }
    

    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        navigationController?.popViewController(animated: false)
        

    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBAction func downloadButton(_ sender: Any) {
       
        convertToPdfFileAndShare(text: summaryTextView.text!)
    }
    
    //MARK: FUNCTIONS
    func convertToPdfFileAndShare(text:String){
        
        let fmt = UIMarkupTextPrintFormatter(markupText: text)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Summary").appendingPathExtension("pdf")
            else { fatalError("Destination URL not created") }
        
        pdfData.write(to: outputURL, atomically: true)
        print("open \(outputURL.path)")
        
        if FileManager.default.fileExists(atPath: outputURL.path){
            
            let url = URL(fileURLWithPath: outputURL.path)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            let excludedActivities = [UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.message, UIActivity.ActivityType.mail, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToTencentWeibo]

                activityViewController.excludedActivityTypes = excludedActivities
            
            
            activityViewController.popoverPresentationController?.sourceView=self.view
            
            //If user on iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                }
            }
            present(activityViewController, animated: true, completion: nil)

        }
        else {
            print("document was not found")
        }
        
    }
    
}
