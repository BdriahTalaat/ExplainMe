//
//  SummaryViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import PDFKit
import SwiftDataTables
import NVActivityIndicatorView

@available(iOS 16.0, *)
class SummaryViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    
    
    //MARK: VARIABLE
    var summaryDelegate:SummaryVideoDelegat?
    var transcibe = ""
    var summaryType = ""
    var dataTable: SwiftDataTable!
    var question:[[String]] = [[]]
    var summary = ""
    var videoURL = ""
    var videoTitle = ""
    var quiz:[String]? = []
    var answer : [String]?
    var video:Video?
    var onDataReceived: ((Video) -> Void)?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.setCircle(View: saveButton, value: 5)
        downloadButton.setCircle(View: downloadButton, value: 5)
        
        summaryTextView.setCircle(View: summaryTextView, value: 40)
        
        downloadButton.isEnabled = false
        saveButton.isEnabled = false
        
        loaderView.startAnimating()
        
        OpenAi.summary(text: "Summarize the following video \(transcibe)") { [self] response in
            
            self.summaryTextView.text = response as! String
            summary = response as! String
            //let text = response as! String
            //let words = text.split(separator: "\n").map { String($0) }
            self.saveButton.isEnabled = true
            self.downloadButton.isEnabled = true
            self.tableView.isHidden = true
            self.loaderView.stopAnimating()
        }
        
        /*if summaryType == "normal"{
            
            
            
        }else {
            
            OpenAi.summary(text: "Summarize as table the following video \(transcibe)") { [self] response in
                
                
                
                let text = response as! String
                summary = response as! String
                
                var str = text.replacingOccurrences(of: "|", with: "")
                str = str.replacingOccurrences(of:"-", with: "")
                str = str.replacingOccurrences(of: "\n", with: "")
                
                var r = str.split(separator: "   ").map { String($0) }
                
                for i in stride(from: 0, to: r.count, by: 2) {
                    let pair = Array(r[i..<min(i + 2, r.count)])
                    self.question.append(pair)
                }
                
                self.question.remove(at: 0)
                let header = self.question[0]
                
                self.question.remove(at: 0)
                self.question.remove(at: self.question.count-1)
                
                var options = DataTableConfiguration()
                options.shouldShowSearchSection = false
                options.shouldShowFooter = false
                
                
                dataTable = SwiftDataTable(data: self.question, headerTitles: header, options: options)
                
                
                dataTable.translatesAutoresizingMaskIntoConstraints = false
                tableView.addSubview(dataTable)
                
                //----------------------
                
                

        
                //---------------------
                // Layout constraints
                NSLayoutConstraint.activate([
                    dataTable.topAnchor.constraint(equalTo: tableView.topAnchor),
                    dataTable.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
                    dataTable.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                    dataTable.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
                ])
                
                print(self.question)
                self.downloadButton.isEnabled = true
                self.saveButton.isEnabled = true
                self.loaderView.stopAnimating()
            }
        }*/

    }
    

    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        navigationController?.popViewController(animated: false)
        

    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "quiz screen") as! QuizViewController
       
        summaryDelegate?.didSelectSummaryDelegate(summary:summary )
        let videoData = Video(summary: summary, quiz: quiz, answer:self.answer, videoURL: self.videoURL)
        
        //print(vc.quiz)
        print(videoData)
        print(onDataReceived?(videoData))
        
        
        AppManager.shared.add1(summary: videoData.summary, quiz: videoData.quiz, videoURL: videoData.videoURL, answer: videoData.answer, videoTitle: videoTitle){ [self] response in
           
            //self.video.quiz = vc.question
            //self.video.summary = self.summary
            //self.video.videoURL = self.videoURL
            let alert = UIAlertController(title: "Success", message: "The summary is saved" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
             print(response)
            
             alert.addAction(okAction)
             self.present(alert, animated: true)
            
        }
        
    }
    
    @IBAction func downloadButton(_ sender: Any) {
       
        convertToPdfFileAndShare(text: summaryTextView.text!)
        /*if summaryType == "normal"{
            convertToPdfFileAndShare(text: summaryTextView.text!)
        }else{
            if let pdfData = convertDataTableToPDF(dataTable: dataTable) {
                        saveAndSharePDF(pdfData: pdfData)
            }
        }*/
        
    }
    
    //MARK: FUNCTIONS
    
    func convertDataTableToPDF(dataTable: SwiftDataTable) -> Data? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: dataTable.bounds)
        return pdfRenderer.pdfData { context in
            context.beginPage()
            dataTable.layer.render(in: context.cgContext)
        }
    }
    
    func saveAndSharePDF(pdfData: Data) {
        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // For iPad
        present(activityViewController, animated: true, completion: nil)
    }
    
    
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
//MARK: EXTENTION
extension UIView {
    func convertToPdfFileAndShare() {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, bounds, nil)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            print("Failed to get PDF context")
            return
        }

        layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
protocol SummaryVideoDelegat{
    func didSelectSummaryDelegate(summary:String?)
}
