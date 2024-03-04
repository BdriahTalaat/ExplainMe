//
//  ViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 16/06/1445 AH.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LoginButtton: UIButton!
    
    //MARK: VARIABLS

    //MARK: LIFT CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignUpButton.setCircle(View: SignUpButton, value: 5)
        LoginButtton.setCircle(View: LoginButtton, value: 5)
        
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            if Auth.auth().currentUser != nil {
              // User is signed in.
                
                let vc =  self.storyboard?.instantiateViewController(identifier: "tab bar screen") as! UITabBarController
                
                AppManager.shared.listen {
                    DispatchQueue.main.async {
                        //self.navigationController?.pushViewController(vc, animated: false)
                        self.present(vc, animated: false)
                    }
                }
            }
        }
        
        
    }

    //MARK: ACTIONS
     
    @IBAction func LoginButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Login screen") as! LoginViewController as LoginViewController
        
        navigationItem.backButtonTitle = ""
        vc.navigationItem.title = "ExplainMe"
        navigationController?.pushViewController(vc, animated: false)
        
        //present(vc, animated: false)
    }
    @IBAction func SignUpButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Sign up screen") as! SignUpViewController
        
        vc.navigationItem.title = "ExplainMe"
        navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: false)
    }
    
}

