//
//  OpenAI.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 22/08/1445 AH.
//

import Foundation
import Alamofire

class OpenAi:API {
    
    static func getVideoDetails(url: String, completionHandler : @escaping(Any)->()) {
        let parameters: [String: Any] = [
            "url": url
        ]
        
        let downloadURL = "https://loadify.madrasvalley.com/api/yt/details"
        
        AF.request(downloadURL, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                if let json = value as? [String: Any],
                   let title = json["title"] as? String {
                    
                    // Handle the API response as needed
                    completionHandler(title)
                }
                case .failure(let error):
                    print("API request error: \(error)")
                    // Handle the API request error
                
            }
        }
    }
    
    

    static func downloadYouTubeVideo(url: String, videoQuality: String , completionHandler : @escaping(Any)->()) {
        let parameters: [String: Any] = [
            "url": url,
            "video_quality": videoQuality
        ]

        let downloadURL = "https://loadify.madrasvalley.com/api/yt/download/video/mp4"

        AF.download(downloadURL, method: .get, parameters: parameters, headers: nil, to: { (_, _) -> (destinationURL: URL, options: DownloadRequest.Options) in
            let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("video.mp4")
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        })
        .validate()
        .downloadProgress { progress in
            
            //print("Download Progress: \(progress.fractionCompleted)")
        }
        .response { [self] response in
            
            
            if let error = response.error {
                print("Error downloading video: \(error.localizedDescription.description)")
            } else {
                print("Video downloaded successfully")
                let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("video.mp4")
                // Use the downloaded file at destinationURL
                
                OpenAi.tranciption(file: destinationURL.relativePath) { response,error  in
                    
                    if error != nil{
                        print(error?.localizedDescription.description)
                    }
                    completionHandler(response)
                    
                }
                
            }
        }
    }
    
    //MARK: GET TRANCIPTION
    
    static func tranciption(file: String, completionHandler: @escaping (Any?, Error?) -> Void) {
        let URLTranscription = "\(OpenAi.baseURL)audio/transcriptions"
        let parameters: [String: Any] = [
            "file": URL(fileURLWithPath: file),
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
            to: URLTranscription,
            method: .post,
            headers: OpenAi.headers
        )
        .responseJSON { response in
            switch response.result {
            case .success(let text):
                print("Response: \(text)")
                completionHandler(text, nil)
            case .failure(let error):
                print("Error: \(error)")
                if let responseData = response.data,
                   let errorJson = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let errorCode = errorJson["error"] as? [String: Any],
                   let code = errorCode["code"] as? String,
                   code == "insufficient_quota" {
                    // Handle insufficient quota error
                    completionHandler(nil, NSError(domain: "com.yourapp.error", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Insufficient quota. Please check your plan and billing details."]))
                } else {
                    // Handle other errors
                    completionHandler(nil, error)
                }
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
                
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    //MARK: GET CHATGPT (from video knowlege)
    static func videoKnowlelege(text:Any ,contentVideo:Any, completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "can You answer my accordingly this data \(contentVideo) \n \(text) \n if request not found in data send me I dont knowlege "]]
            
        ]
        
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    //MARK: GET CHATGPT (from video knowlege)
    static func bothKnowlelege(text:Any ,contentVideo:Any, completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "can You answer my accordingly this data \(contentVideo) and your knowlege \n \(text) "]]
            
        ]
        
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    
    //MARK: GET SUMMARY
    static func summary(text: String , completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": text]]
            
        ]
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                
                completionHandler(message.choices.first!.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
    
    
    
    //MARK: GET SOME QUIZ
    static func quiz(text:Any ,number:String, completionHandler : @escaping(Any)->()){
        
        let URLChat = "\(baseURL)chat/completions"
        let parameters:[String:Any] =
        [
            "model":"gpt-3.5-turbo",
            "messages":[["role": "user","content": "Generate open end quiz \(number) questions based on the following video \(text)"]]
            
        ]
        
        AF.request(URLChat, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            
            do {
                let message =  try JSONDecoder().decode(SmartAssistantModel.self, from: response.data!)
                
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
                
                completionHandler(message.choices.first?.message.content)
                
            }catch let error {
                print(error)
            }
        }
    }
}

