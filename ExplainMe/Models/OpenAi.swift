//
//  OpenAi.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 22/08/1445 AH.
//

import Foundation
import UIKit

struct SmartAssistantModel: Codable{
    var choices: [choices]
    
}

struct choices:Codable{
    var message:message
}

struct message:Codable{
    var content : String
    var role: String
}
