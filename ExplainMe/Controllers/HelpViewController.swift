//
//  HelpViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 13/07/1445 AH.
//

import UIKit

class HelpViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var helpCollectionView: UICollectionView!
    
    //MARK: VARIABLES
    var help:[Help] = [Help(image: UIImage(named: "home screen")! , text: "Enter your link video from youtube then click submit"),
                       Help(image: UIImage(named: "video screen")!, text: "will view your video and you canchoose the service you want"),
                       Help(image: UIImage(named: "smartAssistant screen")!, text: "frist you have to choose any method to can use chat with smart assistant \n\n Note: you can choose method in any time"),
                       Help(image: UIImage(named: "quiz screen")!, text: "will generate quiz and you can answer each question you have two option \n 1.submit to show mark and correct answer \n 2.save to save quiz in database"),
                       Help(image: UIImage(named: "summary screen")!, text: "will generate summary you have two option \n 1.download summary will download in your device \n 2.save to save quiz in database"),
                       Help(image: UIImage(named: "videos screen")!, text: "view all videos that save quiz , summary or both")]
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        helpCollectionView.delegate = self
        helpCollectionView.dataSource = self
        
        //pageControl.numberOfPages = help.count
        
    }
    

    

}
//MARK: EXTENTION
extension HelpViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        help.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "help cell", for: indexPath) as! HelpCollectionViewCell
        let data = help[indexPath.row]
        
        cell.pageControl.numberOfPages = help.count
        cell.pageControl.currentPage = indexPath.row
        cell.helpImage.image = data.image
        cell.describeHelpLabel.text = data.text
        
        return cell
    }
    
    
}
