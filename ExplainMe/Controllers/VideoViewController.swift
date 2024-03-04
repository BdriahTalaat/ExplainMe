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

class VideoViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var videoView: YoutubePlayerView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var smartAssistantView: UIView!
    @IBOutlet weak var fromVideoButton: UIButton!
    @IBOutlet weak var fromKnowlegeButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fromBothButton: UIButton!
    @IBOutlet weak var methodView: UIView!
    @IBOutlet weak var imageView: UIView!
        
    //MARK: VARIABLE
    var videoLink = ""
    var message:[Chat] = []
    var transcribe = ""
    var assistant : [String]? = []
    
    //MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView.delegate = self
        chatTableView.dataSource = self
        chatTableView.delegate = self
        messageTextView.delegate = self
        
        smartAssistantView.isHidden = true
        
        getThumbnailFromImage(videoId: videoLink)
        
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
        
        message.removeAll()
        chatTableView.reloadData()
    }
    
    @IBAction func smartAssistantButton(_ sender: Any) {
        
       let vc = storyboard!.instantiateViewController(withIdentifier: "smart assistant screen") as! SmartAssistantViewController

        smartAssistantView.isHidden = false
        
    }
    
    @IBAction func quizButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "quiz screen") as! QuizViewController
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func summaryButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "summary screen") as! SummaryViewController
        vc.transcibe = self.transcribe
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        //chatTableView.isHidden = false
        message.append(Chat(message: messageTextView.text, sender: "user"))
        chatTableView.reloadData()
        sendButton.isEnabled = false
        sendButton.isHidden = true
        
        loaderView.startAnimating()
        
        OpenAi.chatKnowlege(text: messageTextView.text!) { [self] response in
            
            message.append(Chat(message: response as! String, sender: "assistant"))
            chatTableView.reloadData()
            sendButton.isHidden = false
            loaderView.stopAnimating()

        }

        messageTextView.text = ""
        
    }
    
    @IBAction func answerButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "From video"{
            
            fromVideoButton.setImage(UIImage(named: "check"), for: .normal)
        }
        else if  sender.titleLabel?.text == "From my Knowlege"{
            
            fromKnowlegeButton.setImage(UIImage(named: "check"), for: .normal)
        }
        else if  sender.titleLabel?.text == "Both from video and my Knowlege"{
            
            fromBothButton.setImage(UIImage(named: "check"), for: .normal)
            
            //setImage(.init(systemName: "circle"), for: .normal)
            
        }else{
            print(sender.titleLabel?.text)
        }
        fromVideoButton.isEnabled = false
        fromKnowlegeButton.isEnabled = false
        fromBothButton.isEnabled = false
    }
}

//MARK: EXTENTION

extension VideoViewController: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.play()
    }

    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }

    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }

    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }

    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
}

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


extension VideoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "message") as! ChatTableViewCell
        let data = message[indexPath.row]
       
        
        if data.sender == "user"{
           
            messageCell.assistantViewMessage.isHidden = true
            messageCell.assistantimageView.isHidden = true
            
            messageCell.imagView.setCircle(View: messageCell.imagView, value: 2)
            messageCell.viewMessage.setCircle(View: messageCell.viewMessage, value: 12)
            messageCell.messageLabel.text = data.message
            
            return messageCell
            
        }else if data.sender == "assistant"{
            
           
            messageCell.imagView.isHidden = true
            messageCell.viewMessage.isHidden = true
            
            messageCell.assistantimageView.setCircle(View: messageCell.assistantimageView, value: 2)
            messageCell.assistantViewMessage.setCircle(View: messageCell.assistantViewMessage, value: 12)
            messageCell.assistantLabel.text = data.message
            
            return messageCell
            
        }else{
            return messageCell
        }
        
    }
    
}

extension VideoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if messageTextView.text.isEmpty || messageTextView.text == "" {
            
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
   
}
