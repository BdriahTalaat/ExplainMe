//
//  ResetPasswordViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 20/06/1445 AH.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var sendInstructionButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        sendInstructionButton.setCircle(View: sendInstructionButton, value: 5)
    }
    
    
    //MARK: ACTIONS
    
    @IBAction func sendInstructionButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Password", message: "Are you sure you want reset password", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){_ in
            self.dismiss(animated: false)
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [self] _ in
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                print(error?.localizedDescription.description)
                dismiss(animated: false)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true)
        
        
    }
    
}
