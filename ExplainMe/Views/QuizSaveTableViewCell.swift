//
//  QuizSaveTableViewCell.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 14/09/1445 AH.
//

import UIKit

class QuizSaveTableViewCell: UITableViewCell {

    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        answerTextView.setCircle(View: answerTextView, value: 15)
        
        answerTextView.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
