//
//  AssistantTableViewCell.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 22/08/1445 AH.
//

import UIKit
import NVActivityIndicatorView

class AssistantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var assistantImage: UIImageView!
    @IBOutlet weak var assistantImageView: UIView!
    @IBOutlet weak var assistantView: UIView!
    @IBOutlet weak var assistantLabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
