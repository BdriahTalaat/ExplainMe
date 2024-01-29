//
//  Extention View.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 20/06/1445 AH.
//

import Foundation
import UIKit

extension UIView{
    
    func setCircle (View:UIView , value : CGFloat){
        View.layer.cornerRadius = View.frame.height / value

    }
}
