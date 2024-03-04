//
//  LoginViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 20/06/1445 AH.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn


class LoginViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var seePasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: LIFT CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        LoginButton.setCircle(View: LoginButton, value: 5)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    //MARK: ACTIONS
    
    @IBAction func LoginButton(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
              
               
                if user != nil{
                    
                    let vc = self?.storyboard?.instantiateViewController(identifier: "tab bar screen") as! UITabBarController
                   
                    AppManager.shared.listen {
                        DispatchQueue.main.async {
                            //self!.navigationController?.pushViewController(vc, animated: false)
                            self!.present(vc, animated: false)
                            
                            self?.emailTextField.text = ""
                            self?.passwordTextField.text = ""
                        }
                    }
                    
                }else {
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription.description)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                        self?.emailTextField.text = ""
                        self?.passwordTextField.text  = ""

                    }
                    
                    alert.addAction(okAction)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func SignUpButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "Sign up screen") as! SignUpViewController
        
        vc.navigationItem.title = "ExplainMe"
        navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: false)
    }
    
    
    @IBAction func ResetPasswordButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Reset Password") as! ResetPasswordViewController
        
        vc.navigationItem.title = "ExplainMe"
        navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: false)
    }
    
    @IBAction func seePasswordAction(_ sender: UIButton) {
        
        passwordTextField.privatePassword(txtField: passwordTextField, button: seePasswordButton, icon1: "eye.slash.circle", icon2: "eye.circle")
    }
    
}

//MARK: EXTENTION
extension LoginViewController : UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
        return true
    }
  
}



