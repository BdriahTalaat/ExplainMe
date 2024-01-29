//
//  User.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 02/07/1445 AH.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable{
   
    let userName : String
    let email : String
    let uid : String
    @DocumentID var DocId : String?
}
