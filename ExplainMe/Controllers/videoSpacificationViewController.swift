//
//  videoSpacificationViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 13/09/1445 AH.
//

import UIKit

class videoSpacificationViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    //MARK: VIRIABLE
    var video:Video?
    var index = 2
    var d : [String:Any?] = [:]
    var key : [String] = []
    var answer : [String] = []
    //var details : [String:Any] = video
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        
        /*if video?.summary == nil || video?.quiz == nil{
            index = index - 1
        }*/
        // Do any additional setup after loading the view.
        
        let data : [String : Any?] = ["Summary":video?.summary,"Quiz":video?.quiz]
        
        //var d : [String:Any?] = [:]
        //print(data)
        
        // Check if the "Summary" value is nil
        if data["Summary"] as! String == ""{
            print("Summary is nil")
        } else {
            //print("Summary is not nil")
            d["Summary"] =  data["Summary"]
        }

        // Check if the "Quiz" value is nil
        if let quiz = data["Quiz"] as? [String] {
            
            //print("Quiz is not nil")
            d["Quiz"] =  data["Quiz"]
        } else {
            //print("Quiz is nil")
        }
        for key in d.keys {
            
            self.key.append(key)
        }
        
    }
    

    

}

//MARK: EXTENTION
extension videoSpacificationViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return key.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! videoSpacificationCollectionViewCell
        
        cell.titleLabel.text! = key[indexPath.row]
        cell.layer.cornerRadius = cell.frame.height/6
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = key[indexPath.row]
        
        if selected == "Quiz"{
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "quiz save") as! QuizSaveViewController
            vc.qeustion = (video?.quiz)!
            vc.answer = video?.answer ?? []
            
            navigationController?.pushViewController(vc, animated: false)
            
        }else{
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "summary save") as! SummarySaveViewController
            vc.summary = video?.summary

            navigationController?.pushViewController(vc, animated: false)
        }
        
    }
}
