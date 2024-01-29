//
//  SummaryViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit

class SummaryViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var downloadButton: UIButton!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.setCircle(View: saveButton, value: 5)
        downloadButton.setCircle(View: downloadButton, value: 5)
        
        summaryTextView.setCircle(View: summaryTextView, value: 40)
        summaryTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        
    }
    

    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        navigationController?.popViewController(animated: false)
        

    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBAction func downloadButton(_ sender: Any) {
    }
}
