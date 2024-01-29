//
//  QuizTableViewCell.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 06/07/1445 AH.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var qustionLabel: UILabel!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answerTextView.setCircle(View: answerTextView, value: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
