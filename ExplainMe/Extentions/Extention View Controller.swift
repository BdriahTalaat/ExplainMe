//
//  Extention View Controller.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 04/07/1445 AH.
//

import Foundation
import UIKit

extension UIViewController{
   
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
