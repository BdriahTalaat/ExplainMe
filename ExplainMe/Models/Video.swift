//
//  Video.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 05/09/1445 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Videos : Identifiable,Codable{
    @DocumentID var DocId : String?
    var id = UUID()
    let user : String
    var video:[Video]
}

struct Video : Identifiable,Codable{
    var id = UUID()
    var summary : String?
    var quiz : [String]?
    var answer : [String]?
    var videoTitle : String?
    var videoURL : String

}

struct Help{
    var image : UIImage
    var text : String
}
