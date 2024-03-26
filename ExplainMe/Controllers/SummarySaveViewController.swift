//
//  SummarySaveViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 14/09/1445 AH.
//

import UIKit

class SummarySaveViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var summaryTextView: UITextView!
    
    
    //MARK: VARIABLE
    var summary :String!
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        print(summary)
        summaryTextView.text = summary
        summaryTextView.setCircle(View: summaryTextView, value: 40)
    }
    

    

}
