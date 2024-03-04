//
//  HomeViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import NVActivityIndicatorView
import YoutubePlayerView

class HomeViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var videoLinkTextField: UITextField!
    
    //MARK: VARIABLE
   // var videoLink = ""
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.setCircle(View: submitButton, value: 8)
        submitButton.isEnabled = false
    }
    
    //MARK: FUNCTIONS
    
    // This function uses a regular expression to extract the YouTube video ID from a given URL. If the URL matches the expected format, it returns the video ID; otherwise, it returns nil
    
    func extractYouTubeVideoID(from urlString: String) -> String? {
        // Regular expression pattern for matching YouTube video IDs
        let pattern = #"(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: urlString.utf16.count)
            if let match = regex.firstMatch(in: urlString, options: [], range: range) {
                let videoIDRange = Range(match.range(at: 1), in: urlString)
                return videoIDRange.map { String(urlString[$0]) }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }

        return nil
    }

    
    //MARK: ACTIONS
    @IBAction func submitButton(_ sender: Any) {
        
        if let videoID = extractYouTubeVideoID(from: videoLinkTextField.text!) {
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "video screen") as! VideoViewController
            
            vc.videoLink = videoID
            
            loaderView.startAnimating()
            
            OpenAi.tranciption(file: "") { response in
                vc.transcribe = "\(response)"
                self.loaderView.stopAnimating()
                self.navigationController?.pushViewController(vc, animated: false)
                self.videoLinkTextField.text = nil
            }
            
        } else {
           
            let alert = UIAlertController(title: "Error", message: "Not a valid YouTube video link.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                self.videoLinkTextField.text = ""
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
       
    }
    
    @IBAction func videoLinkTextField(_ sender: Any) {
        if videoLinkTextField.text == "" || videoLinkTextField.text == nil{
            submitButton.isEnabled = false
        }else{
            submitButton.isEnabled = true
        }
    }
}


