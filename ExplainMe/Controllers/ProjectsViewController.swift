//
//  ProjectsViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit

class ProjectsViewController: UIViewController {

    //MARK: OUTLETS 
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        projectCollectionView.dataSource = self
        projectCollectionView.delegate = self
    }
    

    //MARK: ACTIONS

}

//MARK: EXTENTIONS
extension ProjectsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "project cell", for: indexPath) as! ProjectCollectionViewCell
        
        cell.titleLabel.text = "What AI"
        cell.projectImage.image = UIImage(named: "user")
        
        return cell
    }
    
    
}
