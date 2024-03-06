//
//  OpenAI.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 22/08/1445 AH.
//

import Foundation
import Alamofire

class OpenAi:API {
    
    //MARK: GET TRANCIPTION
    static func tranciption(file:String , completionHandler : @escaping(Any)->()){
        
        let URLTranciption = "\(OpenAi.baseURL)audio/transcriptions"
        let parameters: [String: Any] = [
            "file": URL(fileURLWithPath:"Users/bdriahtalaat/Desktop/sample/sample/Data/Tree data structures in 2 minutes 🌳.mp4"),
            "model": "whisper-1"
        ]
        
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let fileURL = value as? URL {
                        if let data = try? Data(contentsOf: fileURL) {
                            multipartFormData.append(data, withName: key, fileName: fileURL.lastPathComponent, mimeType: "video/mp4")
                        }
                    } else if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: URLTranciption,
            method: .post,
            headers: OpenAi.headers
        )
        .responseJSON { response in
            switch response.result {
           
            case .success(let text):
                //print("Response: \(text)")
                completionHandler(text)
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //MARK: GET CHATGPT (from chat knowelege)
    static func chatKnowlege(text:Any , completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": text]]
            
        ]
        
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                //print(message.choices.first?.message.content)
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    //MARK: GET CHATGPT (from video knowlege)
    static func videoKnoelege(text:String){
        
    }
    
    
    //MARK: GET SUMMARY
    static func summary(text:Any , completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "Summarize as table formate the following video \(text)"]]
            
        ]
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                //print(message.choices.first?.message.content)
                completionHandler(message.choices.first!.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    
    
    //MARK: GET SOME QUIZ
    static func quiz(text:Any , completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "Generate open end quiz questions based on the following video \(text)"]]
            
        ]
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                //print(message.choices.first?.message.content)
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    static func answer(text:Any , completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "\(text)"]]
            
        ]
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                //print(message.choices.first?.message.content)
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
}

