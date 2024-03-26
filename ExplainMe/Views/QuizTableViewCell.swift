//
//  QuizTableViewCell.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 06/07/1445 AH.
//

import UIKit

class QuizTableViewCell: UITableViewCell , UITextViewDelegate  {

    //MARK: OUTLETS
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var qustionLabel: UILabel!
    
    
    //MARK: VARIABLES
    var textChanged: ((String) -> Void)?
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answerTextView.delegate = self
        answerTextView.setCircle(View: answerTextView, value: 15)
    }

    func textViewDidChange(_ textView: UITextView) {
            textChanged?(textView.text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
