//
//  videoViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 04/07/1445 AH.
//

import UIKit
import AVKit
import Foundation
import NVActivityIndicatorView
import YoutubePlayerView
import BonsaiController

@available(iOS 16.0, *)
class VideoViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var videoView: YoutubePlayerView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var smartAssistantView: UIView!
    @IBOutlet weak var videoTitleLable: UILabel!
    @IBOutlet weak var fromVideoButton: UIButton!
    @IBOutlet weak var fromKnowlegeButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fromBothButton: UIButton!
    @IBOutlet weak var methodView: UIView!
    @IBOutlet weak var imageView: UIView!
        
    //MARK: VARIABLE
    
    var videoLinkId = ""
    var videoLink = ""
    var message:[Chat] = []
    var transcribe = ""
    var assistant : [String]? = []
    
    var videoTitle = ""
    var answer : [String]?
    var quiz :[String]?
    var summary:String?
    
    //MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.isEditable = false
//        print(transcribe)
        videoView.delegate = self
        chatTableView.dataSource = self
        chatTableView.delegate = self
        messageTextView.delegate = self
        
        smartAssistantView.isHidden = true
        
        videoTitleLable.text! = videoTitle
        
        getThumbnailFromImage(videoId: videoLinkId)
        
        messageTextView.setCircle(View: messageTextView, value: 5)
        methodView.setCircle(View: methodView, value: 12)
        imageView.setCircle(View: imageView, value: 2)
        
        fromBothButton.setImage(.init(systemName: "circle"), for: .normal)
        fromVideoButton.setImage(.init(systemName: "circle"), for: .normal)
        fromKnowlegeButton.setImage(.init(systemName: "circle"), for: .normal)
        
        if messageTextView.text == ""{
            sendButton.isEnabled = false
            //chatTableView.isHidden = true
        }
        
    }
    
    //MARK: FUNCTIONS
    
    // play youtube video
    func getThumbnailFromImage(videoId:String){
       
        DispatchQueue.global().async { [self] in
            let playerVars: [String: Any] = [
                "controls": 1,
                "modestbranding": 1,
                "playsinline": 1,
                "rel": 0,
                "showinfo": 0,
                "autoplay": 1
            ]
            
            do{
                self.videoView.loadWithVideoId(videoId, with: playerVars)
                
            }catch{
                print(error.localizedDescription.description)
            }
            
        }
    }
    
    
    //MARK: ACTIONS
    
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "tab bar screen") as! UITabBarController
        navigationController?.popViewController(animated: false)
    }

    @IBAction func closeButton(_ sender: Any) {
        smartAssistantView.isHidden = true
        
        fromBothButton.isEnabled = true
        fromBothButton.setImage(.init(systemName: "circle"), for: .normal)
        
        fromVideoButton.isEnabled = true
        fromVideoButton.setImage(.init(systemName: "circle"), for: .normal)
        
        fromKnowlegeButton.isEnabled = true
        fromKnowlegeButton.setImage(.init(systemName: "circle"), for: .normal)
        
        messageTextView.text = nil
        messageTextView.isEditable = false
        message.removeAll()
        chatTableView.reloadData()
    }
    
    @IBAction func smartAssistantButton(_ sender: Any) {
        
        smartAssistantView.isHidden = false
        
    }
    
    @IBAction func quizButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "quiz screen") as! QuizViewController
        vc.quizDelegate = self
        vc.sammary = self.summary
        vc.videoTitle = self.videoTitle
        
        let alert = UIAlertController(title: "How many question do you want ?", message: "Choose number 5 , 10 or 15", preferredStyle: .alert)
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let five = UIAlertAction(title: "5 Questions", style: .default) { action in
           
            vc.quastionNumber = "5"
            vc.transcribe = self.transcribe
            vc.videoURL = self.videoLink
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        let ten = UIAlertAction(title: "10 Questions", style: .default) { action in
            
            vc.quastionNumber = "10"
            vc.transcribe = self.transcribe
            vc.videoURL = self.videoLink
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        let fifteen = UIAlertAction(title: "15 Questions", style: .default) { action in
            
            vc.quastionNumber = "15"
            vc.transcribe = self.transcribe
            vc.videoURL = self.videoLink
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
                
                
        alert.addAction(cancelAction)
        alert.addAction(fifteen)
        alert.addAction(ten)
        alert.addAction(five)
                
        present(alert, animated: true, completion: nil)
        

    }
    
    @IBAction func summaryButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "summary screen") as! SummaryViewController
        vc.transcibe = self.transcribe
        vc.quiz = quiz
        vc.videoTitle = self.videoTitle
        vc.answer = self.answer
        vc.summaryDelegate = self
        vc.videoURL = self.videoLink
        self.navigationController?.pushViewController(vc, animated: false)
        
        /*let alert = UIAlertController(title: "Summary", message: "What summary type do you want ?", preferredStyle: .alert)
        let tableAlert = UIAlertAction(title: "Table", style: .default) { [self] action in
            vc.summaryType = "table"
            vc.videoURL = videoLink
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        let normalAlert = UIAlertAction(title: "Normal", style: .default) { [self] action in
            vc.summaryType = "normal"
            vc.videoURL = videoLink
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAlert)
        alert.addAction(tableAlert)
        alert.addAction(normalAlert)
        present(alert, animated: true, completion: nil)
        */
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        //chatTableView.isHidden = false
        message.append(Chat(message: messageTextView.text, sender: "user"))
        chatTableView.reloadData()
        sendButton.isEnabled = false
        sendButton.isHidden = true
        
        loaderView.startAnimating()
        

        if fromVideoButton.isSelected{
            
            OpenAi.videoKnowlelege(text: messageTextView.text!, contentVideo: transcribe) { [self] response in
               
                message.append(Chat(message: response as! String, sender: "assistant"))
                chatTableView.reloadData()
                sendButton.isHidden = false
                loaderView.stopAnimating()
            }
            
        }else if fromKnowlegeButton.isSelected{
            
            OpenAi.chatKnowlege(text: messageTextView.text!) { [self] response in
                
                message.append(Chat(message: response as! String, sender: "assistant"))
                chatTableView.reloadData()
                sendButton.isHidden = false
                loaderView.stopAnimating()

            }
            
        }else if fromBothButton.isSelected{
            
            OpenAi.bothKnowlelege(text: messageTextView.text!, contentVideo: transcribe) { [self] response in
                message.append(Chat(message: response as! String, sender: "assistant"))
                chatTableView.reloadData()
                sendButton.isHidden = false
                loaderView.stopAnimating()
            }
            
        }else{
            print("error")
        }
        messageTextView.text = ""
        
    }
    
    

    
    
    @IBAction func answerButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "From video"{
            
            fromBothButton.setImage(.init(systemName: "circle"), for: .normal)
            fromKnowlegeButton.setImage(.init(systemName: "circle"), for: .normal)
            fromVideoButton.setImage(UIImage(named: "check"), for: .normal)
            fromVideoButton.isSelected = true
            fromKnowlegeButton.isSelected = false
            fromBothButton.isSelected = false
        }
        else if  sender.titleLabel?.text == "From my Knowlege"{
            
            fromBothButton.setImage(.init(systemName: "circle"), for: .normal)
            fromVideoButton.setImage(.init(systemName: "circle"), for: .normal)
            fromKnowlegeButton.setImage(UIImage(named: "check"), for: .normal)
            fromBothButton.isSelected = false
            fromVideoButton.isSelected = false
            fromKnowlegeButton.isSelected = true
        }
        else if  sender.titleLabel?.text == "Both from video and my Knowlege"{
            
            fromKnowlegeButton.setImage(.init(systemName: "circle"), for: .normal)
            fromVideoButton.setImage(.init(systemName: "circle"), for: .normal)
            fromBothButton.setImage(UIImage(named: "check"), for: .normal)
            fromBothButton.isSelected = true
            fromVideoButton.isSelected = false
            fromKnowlegeButton.isSelected = false
            //setImage(.init(systemName: "circle"), for: .normal)
            
        }else{
            print(sender.titleLabel?.text)
        }
        
        messageTextView.isEditable = true
        
    }
    
   
}

//MARK: EXTENTION

@available(iOS 16.0, *)
extension VideoViewController: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        
        playerView.play()
    }

    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {}

    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {}

    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }

    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {}
}

@available(iOS 16.0, *)
extension VideoViewController : BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 3), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
        /// With Background Color ///
    
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0), presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    
    
        /// With Blur Style ///
        
        // Slide animation from .left, .right, .top, .bottom
        //return BonsaiController(fromDirection: .bottom, blurEffectStyle: .light, presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}


@available(iOS 16.0, *)
extension VideoViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! ChatTableViewCell
        let data = message[indexPath.row]

        messageCell.imagView.isHidden = true
        messageCell.viewMessage.isHidden = true
        messageCell.assistantimageView.isHidden = true
        messageCell.assistantViewMessage.isHidden = true

        messageCell.imagView.setCircle(View: messageCell.imagView, value: 2)
        messageCell.viewMessage.setCircle(View: messageCell.viewMessage, value: 12)
        messageCell.assistantimageView.setCircle(View: messageCell.assistantimageView, value: 2)
        messageCell.assistantViewMessage.setCircle(View: messageCell.assistantViewMessage, value: 12)

        if data.sender == "user" {
            
            messageCell.messageLabel.text = data.message
            messageCell.assistantLabel.text = data.message
            messageCell.messageLabel.isHidden = false
            messageCell.assistantLabel.isHidden = true
            messageCell.imagView.isHidden = false
            messageCell.viewMessage.isHidden = false
            
        } else if data.sender == "assistant" {
            
            messageCell.messageLabel.text = data.message
            messageCell.assistantLabel.text = data.message
            messageCell.messageLabel.isHidden = true
            messageCell.assistantLabel.isHidden = false
            messageCell.assistantimageView.isHidden = false
            messageCell.assistantViewMessage.isHidden = false
            
        }

        return messageCell
        
    }
    
}

@available(iOS 16.0, *)
extension VideoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if messageTextView.text.isEmpty || messageTextView.text == "" {
            
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
   
}
@available(iOS 16.0, *)
extension VideoViewController:QuizVideoDelegat{
    func didSelectQuizDelegate(quize: [String]?, answer: [String]?) {
        self.quiz = quize
        self.answer = answer
    }
    
   
    
    
}

@available(iOS 16.0, *)
extension VideoViewController:SummaryVideoDelegat{
    func didSelectSummaryDelegate(summary: String?) {
        self.summary = summary
    }
    
}
