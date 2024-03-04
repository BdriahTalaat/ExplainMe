//
//  ChatTableViewCell.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 06/07/1445 AH.
//

import UIKit
import NVActivityIndicatorView

class ChatTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imagView: UIView!
    @IBOutlet weak var assistantViewMessage: UIView!
    @IBOutlet weak var assistantLabel: UILabel!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var assistantimageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
