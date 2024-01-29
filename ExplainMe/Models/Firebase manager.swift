//
//  Firebase manager.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 10/07/1445 AH.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManeger : NSObject{
    
    let auth : Auth
    let storage : Storage
    let firestore : Firestore
    
    static let shared = FirebaseManeger()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
}
