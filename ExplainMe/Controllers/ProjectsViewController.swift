//
//  ProjectsViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import NVActivityIndicatorView

class ProjectsViewController: UIViewController {

    //MARK: OUTLETS 
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    //MARK: VIRIABLE
    var video:[Video]?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        projectCollectionView.dataSource = self
        projectCollectionView.delegate = self
        
        projectCollectionView.allowsSelection = true
        projectCollectionView.allowsMultipleSelection = true
        
        loaderView.startAnimating()
        AppManager.shared.getVideoData { response in
            
            self.video = response
            self.projectCollectionView.reloadData()
            self.loaderView.stopAnimating()
        }
        
    }
    

    //MARK: ACTIONS

}

//MARK: EXTENTIONS
@available(iOS 16.0, *)
extension ProjectsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return video?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "project cell", for: indexPath) as! ProjectCollectionViewCell
        
        let data = video?[indexPath.row]
        
        cell.titleLabel.text = data?.videoTitle
        cell.layer.cornerRadius = cell.frame.height/6
        //cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "videoSpacification") as! videoSpacificationViewController
        let data = video?[indexPath.row]
        
        //let vc1 = storyboard!.instantiateViewController(withIdentifier: "home screen") as! HomeViewController
        
        /*let data = video?[indexPath.row]
       
        loaderView.startAnimating()
        if let videoID = AppManager.shared.extractYouTubeVideoID(from: data!.videoURL){
            
            
            OpenAi.downloadYouTubeVideo(url: data!.videoURL, videoQuality: "Medium") { response in
                vc.transcribe = "\(response)"
                vc.videoLinkId = videoID
                vc.videoLink = data!.videoURL
                //vc1.videoLinkTextField.text = data?.videoURL
                //self.present(vc, animated: true)
                
                
                self.loaderView.stopAnimating()
            }
            
        }*/
        vc.video = data
        vc.navigationItem.title = data?.videoTitle
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
}
