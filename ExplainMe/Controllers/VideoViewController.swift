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

class VideoViewController: UIViewController {


    //MARK: OUTLETS
    @IBOutlet weak var videoView: YoutubePlayerView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var videoTitleLabel: UILabel!
        
    //MARK: VARIABLE
    var videoLink = ""
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView.delegate = self
        
       
        loaderView.startAnimating()
        getThumbnailFromImage(videoId: videoLink) {
            self.loaderView.stopAnimating()
        }
    }
    
    //MARK: FUNCTIONS
    
    func getThumbnailFromImage(videoId:String , completion:@escaping(()-> Void)){
       
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
                
                DispatchQueue.main.async {
                    completion()
                }
                
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
   
    
    @IBAction func smartAssistantButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "smart assistant screen") as! SmartAssistantViewController
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func quizButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "quiz screen") as! QuizViewController
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func summaryButton(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "summary screen") as! SummaryViewController
        
        navigationController?.pushViewController(vc, animated: false)
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

