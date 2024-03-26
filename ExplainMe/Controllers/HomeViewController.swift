//
//  HomeViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import NVActivityIndicatorView
import YoutubePlayerView

@available(iOS 16.0, *)
class HomeViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var videoLinkTextField: UITextField!
    
    //MARK: VARIABLE
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.setCircle(View: submitButton, value: 8)
        submitButton.isEnabled = false
        
        }
    
    //MARK: FUNCTIONS
    

    
    //MARK: ACTIONS
    @IBAction func submitButton(_ sender: Any) {
        
        if let videoID = AppManager.shared.extractYouTubeVideoID(from: videoLinkTextField.text!) {
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "video screen") as! VideoViewController
            
            vc.videoLinkId = videoID
            vc.videoLink = videoLinkTextField.text!
            
            loaderView.startAnimating()
            
            OpenAi.downloadYouTubeVideo(url: videoLinkTextField.text!, videoQuality: "Medium") { response in
                
                vc.transcribe = "\(response)"
                
                OpenAi.getVideoDetails(url: self.videoLinkTextField.text!) { response in
                 
                    //print(response)
                    vc.videoTitle = "\(response)"
                    self.loaderView.stopAnimating()
                    self.navigationController?.pushViewController(vc, animated: false)
                    self.videoLinkTextField.text = nil
                }
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
    
    @IBAction func helpButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "help screen") as! HelpViewController
        
        vc.navigationItem.title = "Help"
        navigationController?.pushViewController(vc, animated: false)
    }
    
}


