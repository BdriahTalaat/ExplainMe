//
//  SignUpViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 20/06/1445 AH.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn


class SignUpViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var seePaswordButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: VARIABLS
    let db = Firestore.firestore()
    //let userID = Auth.auth().currentUser?.uid
  //  let userEmail = Auth.auth().currentUser?.email
 //   let userCurrent = Auth.auth().currentUser
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.setCircle(View: signUpButton, value: 5)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        googleButton.setCircle(View: googleButton, value: 5)
    }
    

    //MARK: ACTIONS

    @IBAction func SignUpButton(_ sender: UIButton) {
        
        if let email = emailTextField.text , let password = passwordTextField.text , let username = userNameTextField.text{
           
            Auth.auth().createUser(withEmail: email, password: password) { [self] user, error in
                
                guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else{ return }
                
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(identifier: "tab bar screen") as! UITabBarController
                    
                    AppManager.shared.createUser(name: username, email: email, uid: uid)
                   
                    AppManager.shared.listen {
                        DispatchQueue.main.async {
                            //self.navigationController?.pushViewController(vc, animated: false)
                            self.present(vc, animated: false)
                        }
                    }

                    

                }else {
                    let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription.description)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default){ _ in
                        self.emailTextField.text = ""
                        self.passwordTextField.text  = ""
                        self.userNameTextField.text = ""
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func signUpWithGoogle(_ sender: UIButton) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [self] result, error in
          guard error == nil else { return }

          guard let user = result?.user,let idToken = user.idToken?.tokenString else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)

            emailTextField.text = result?.user.profile?.email
            userNameTextField.text = result!.user.profile?.name
        }
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Login screen") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: false)
        //present(vc, animated: false)
    }
    
    
    @IBAction func seePasswordButton(_ sender: Any) {
        passwordTextField.privatePassword(txtField: passwordTextField, button: seePaswordButton, icon1: "eye.slash.circle", icon2: "eye.circle")
    }
    
}

//MARK: EXTENTION
extension SignUpViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField{
            emailTextField.becomeFirstResponder()
            
        }
        
        else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
            
        }else{
            view.endEditing(true)
        }
        return true
    }
    
}
