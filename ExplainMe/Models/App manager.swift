//
//  App manager.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 10/07/1445 AH.
//

import Foundation
import UIKit
import FirebaseAuth

class AppManager{
    static let shared = AppManager()
    var users : [User] = []
    
    //MARK: FUNCTIONS
    
    //create user
    func createUser(name:String , email:String , uid:String){
        let user = User.init(userName: name, email: email, uid: uid)
        
        do{
            
            let newUser = try FirebaseManeger.shared.firestore.collection("users").addDocument(from: user)
            
        }catch{
            print(error.localizedDescription.description)
        }
    }
    
    // Update email
    func updateEmail(newEmail:String , password:String){
        
        let useremail = FirebaseManeger.shared.auth.currentUser?.email
        let current = FirebaseManeger.shared.auth.currentUser
                
        for user in users {
            
            guard let docId = user.DocId else { return }

            if  user.email == useremail{
                FirebaseManeger.shared.firestore.collection("users").document(docId).updateData(["email":newEmail])
                
                if newEmail != useremail{
                    
                    // Reauthenticate the user with their current email and password
                    let credential = EmailAuthProvider.credential(withEmail: newEmail, password: password)
                    current!.reauthenticate(with: credential) { (result, error) in
                        if let error = error {
                            print("Error reauthenticating user: \(error.localizedDescription)")
                        } else {
                            // User reauthenticated successfully, now send email verification to the new email
                            current!.updateEmail(to: newEmail) { (error) in
                                if let error = error {
                                    print("Error updating email: \(error.localizedDescription)")
                                } else {
                                    // Email updated successfully, send verification email
                                    current!.sendEmailVerification { (error) in
                                        if let error = error {
                                            print("Error sending verification email: \(error.localizedDescription)")
                                        } else {
                                            print("Verification email sent to \(newEmail)")
                                            // Provide feedback to the user to check their email for verification
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                   /*
                    current?.updateEmail(to: email){ error in
                        if error != nil{
                            print(error?.localizedDescription.description)
                            print(current?.email)
                        }else{
                            print(current?.email)
                        }
                        
                    }*/
                }
                break
            }

            
        }
    }
    
    
    // Update username
    func updateUsername(username:String){
        
        let userId = FirebaseManeger.shared.auth.currentUser?.uid
        let current = FirebaseManeger.shared.auth.currentUser
                
        for user in users {
            
            guard let docId = user.DocId else { return }

            if  user.uid == userId{
                FirebaseManeger.shared.firestore.collection("users").document(docId).updateData(["userName":username])
                
                
                break
            }

            
        }
    }
    
    // get all users
    func getAllUser()async{
       
        do{
            guard let uid = FirebaseManeger.shared.auth.currentUser?.uid else { return }
            let snapshot = try await FirebaseManeger.shared.firestore.collection("users").getDocuments(source: .server)
            self.users = try snapshot.documents.map{ try $0.data(as: User.self)}
            
        }catch let error{
            print(error.localizedDescription.description)
        }
    }
    
    // get user data
    func getUserData(uid : String) async -> User?{
        if let user = users.first(where:{ $0.uid == uid}){
            return user
        }else{
            do{
                let snapshot = try await FirebaseManeger.shared.firestore.collection("users").whereField("uid", isEqualTo: uid).getDocuments(source: .server)
                
                if let user = try snapshot.documents.first?.data(as: User.self){
                    return user
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getUserData(uid : String) -> User?{
        if let user = users.first(where:{ $0.uid == uid}){
            return user
        }
        return nil
    }
    
    
    
    func listen (_ completion: @escaping () -> ()){
        
        guard let userID = FirebaseManeger.shared.auth.currentUser?.uid  else { return }
        
        Task{
            await getAllUser()
            completion()
        }
    }
    

}
