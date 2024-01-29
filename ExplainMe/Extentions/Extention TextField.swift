//
//  Extention Button.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 04/07/1445 AH.
//

import Foundation
import UIKit

extension UITextField{
    
    func privatePassword(txtField : UITextField , button:UIButton , icon1:String , icon2:String){
        
        txtField.isSecureTextEntry = !(txtField.isSecureTextEntry)
        
        if txtField.isSecureTextEntry == false{
            button.configuration?.image = UIImage(systemName: icon1 )
        }else{
            button.configuration?.image = UIImage(systemName: icon2 )
        }
    }
}


