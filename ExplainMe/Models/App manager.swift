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
    var videos : [Videos] = []
    
    
    //MARK: FUNCTIONS
    
    func getVideoData(completion: @escaping ([Video]) -> ()){
        
        var videos: [Video] = []

        guard let userID = FirebaseManeger.shared.auth.currentUser?.uid else { return }

        FirebaseManeger.shared.firestore.collection("videos").document(userID).collection("video").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }

            for document in documents {
                let data = document.data()
                
                let summary = data["summary"] as? String ?? ""
                let quiz = data["quiz"] as? [String] ?? []
                let videoTitle = document.documentID // Assuming documentID is the videoTitle
                let videoURL = data["videoURL"] as? String ?? ""
                let answer = data["answer"] as? [String] ?? []
                let video = Video(summary: summary, quiz: quiz, answer:answer, videoTitle: videoTitle, videoURL: videoURL)
                
                videos.append(video)
            }

            
            completion(videos)
        }
        
    }
    
    func add1(summary: String?, quiz: [String]?, videoURL: String,answer:[String]?, videoTitle: String?, _ completion: @escaping (Any) -> ()) {
        guard let userID = FirebaseManeger.shared.auth.currentUser?.uid else { return }
        
        let video = Video(summary: summary, quiz: quiz, answer:answer, videoTitle: videoTitle, videoURL: videoURL)
        // Assuming `videoTitle` is unique for each video
        let videoDocRef = FirebaseManeger.shared.firestore.collection("videos").document(userID).collection("video").document(videoTitle!)

        // Save the video data
        videoDocRef.setData([
            "summary": video.summary ?? "",
            "quiz": video.quiz ?? [],
            "answer":video.answer ?? [],
            "videoURL": video.videoURL
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                
                
                // Add a listener to the document reference
                  videoDocRef.addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                          print("Error fetching document: \(error!)")
                          return
                      }
                      guard let data = document.data() else {
                          print("Document data was empty.")
                          return
                      }
                      let summary = data["summary"] as? String ?? ""
                      let quiz = data["quiz"] as? [String] ?? []
                      let videoURL = data["videoURL"] as? String ?? ""
                      let answer = data["answer"] as? [String] ?? []
                      completion(data)
                  }
               
            }
        }

    }
    
    // send action
    func send (videos : Videos , video : Video ){
        guard let docId = videos.DocId else{ return }
        
        do{
            _ = try FirebaseManeger.shared.firestore.collection("videos").document(docId).collection("video").addDocument(from: video)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    //create video
    func createVideo(summary:String? ,quiz:[String]? ,videoURL:String ,videoTitle:String?  , _ completion: @escaping () -> ()){
       
        guard let userID = FirebaseManeger.shared.auth.currentUser?.uid  else{ return }
       // guard let docId = videos.DocId else{ return }
        
        Task{
            
            let video = Video(summary: summary,quiz: quiz, videoTitle: videoTitle, videoURL: videoURL)
                
            guard let userID = FirebaseManeger.shared.auth.currentUser?.uid  else{ return }
            let userRef = FirebaseManeger.shared.firestore.collection("videos").addDocument(data: ["userID":userID])

            // Assuming you want to fetch a single document
            let docRef = FirebaseManeger.shared.firestore.collection("videos").document("your_document_id")

            do {
                // Add the videos to Firestore
                _ = try FirebaseManeger.shared.firestore.collection("videos").addDocument(data: ["user":userID]).collection("video").document(videoTitle!).setData(["summary":video.summary,"quiz":video.quiz ,"videoURL":video.videoURL]) { error in
                    
                    if let error = error {
                        print("Error adding document: \(error)")
                        
                    } else {
                        print("Document added successfully")
                        
                        self.listen {
                            completion()
                        }
                    }
                }
            } catch {
                print("Error encoding videos: \(error)")
            }
               
        }
    }
    
    
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
        
        guard let userId = FirebaseManeger.shared.auth.currentUser?.uid  else { return }
        
        Task{
            await getAllUser()
            
            let snapshot = try await FirebaseManeger.shared.firestore.collection("videos").whereField("users",arrayContains: userId).getDocuments(source: .server)
            
            
            self.videos = try snapshot.documents.map({ try $0.data(as: Videos.self ) })
            var usersIDs : [String] = []
            
            
            completion()
        }
    }
    
    func extractYouTubeVideoID(from urlString: String) -> String? {
        // Regular expression pattern for matching YouTube video IDs
        let pattern = #"(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: urlString.utf16.count)
            if let match = regex.firstMatch(in: urlString, options: [], range: range) {
                let videoIDRange = Range(match.range(at: 1), in: urlString)
                return videoIDRange.map { String(urlString[$0]) }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }

        return nil
    }
    

}
