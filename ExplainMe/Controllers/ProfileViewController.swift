//
//  ProfileViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: VARIABLES
    let user = Auth.auth().currentUser
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        logOutButton.setCircle(View: logOutButton, value: 5)
        
        if let user = user {

            emailTextField.text = user.email
            usernameTextField.text = AppManager.shared.getUserData(uid: user.uid)?.userName
            print(user)
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
          // ...
        }
    }
    
    //MARK: ACTIONS

    @IBAction func helpButton(_ sender: Any) {
    }
    
    @IBAction func userNameEditButton(_ sender: UIButton) {
        
        AppManager.shared.updateUsername(username: usernameTextField.text!)
    }
    
    @IBAction func emailEditButton(_ sender: Any) {
        
        AppManager.shared.updateEmail(newEmail: emailTextField.text!, password: "1234567")
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Out", message: "Are you ture you want log Out ? ", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default){ _ in
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    let vc = self.storyboard?.instantiateViewController(identifier: "first screen")
                    self.present(vc!, animated: false)
                    
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
                
            }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        

    }
   
    
    
}
