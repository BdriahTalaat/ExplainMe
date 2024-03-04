//
//  sampleViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 25/07/1445 AH.
//

import UIKit
import SwiftOpenAI

class sampleViewController: UIViewController {
    
    var openAI = SwiftOpenAI(apiKey: "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")
    
    @IBOutlet weak var video: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submit(_ sender: Any) {
        // Example usage:
        let urlString = "https://www.youtube.com/watch?v=6BVJEcsq5U4"
        convertURLToText(urlString: urlString) { result in
            switch result {
            case .success(let text):
                print("Text received from URL:")
                print(text)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        /* Task { @MainActor in
         // Placeholder for the data from your video or audio file.
         let str = video.text!
         let data = str.data(using: .utf8)
         let url = Bundle.main.url(forResource: "explainMe", withExtension: "mp3")
         
         
         // Specify the transcription model to be used, here 'whisper'.
         let model: OpenAITranscriptionModelType = .whisper
         
         do {
         let fileData = try Data(contentsOf: url!)
         // Attempt to transcribe the audio using OpenAI's transcription service.
         for try await newMessage in try await openAI.createTranscription(
         model: model, // The specified transcription model.
         file: fileData, // The audio data to be transcribed.
         language: "en", // Set the language of the transcription to English.
         prompt: "", // An optional prompt for guiding the transcription, if needed.
         responseFormat: .mp3, // The format of the response. Note: Typically, transcription responses are in text format.
         temperature: 1.0 // The creativity level of the transcription. A value of 1.0 promotes more creative interpretations.
         ) {
         // Print each new transcribed message as it's received.
         print("Received Transcription \(newMessage)")
         
         // Update the UI on the main thread after receiving transcription.
         /*await MainActor.run {
          isLoading = false // Update loading state.
          transcription = newMessage.text // Update the transcription text.
          }*/
         }
         } catch {
         // Handle any errors that occur during the transcription process.
         print(error.localizedDescription)
         }
         }
         }
         */
        
    }
    
    /* // Define a struct to handle configuration settings.
     struct Config {
     // Static variable to access the OpenAI API key.
     static var openAIKey: String {
     get {
     // Attempt to find the path of 'Config.plist' in the main bundle.
     guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
     // If the file is not found, crash with an error message.
     fatalError("Couldn't find file 'Config.plist'.")
     }
     
     // Load the contents of the plist file into an NSDictionary.
     let plist = NSDictionary(contentsOfFile: filePath)
     
     // Attempt to retrieve the value for the 'OpenAI_API_Key' from the plist.
     guard let value = plist?.object(forKey: "OpenAI_API_Key") as? String else {
     // If the key is not found in the plist, crash with an error message.
     fatalError("Couldn't find key 'OpenAI_API_Key' in 'Config.plist'.")
     }
     
     // Return the API key.
     return value
     }
     }
     }
     
     // Initialize an instance of SwiftOpenAI with the API key retrieved from Config.
     var openAI = SwiftOpenAI(apiKey: Config.openAIKey)
     
     
     }*/
    
    
    func convertURLToText(urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Construct the URL for the Whisper API endpoint
        let apiKey = "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"
        let whisperAPIURL = URL(string: "https://api.whisper.ai/v1/convert?url=\(urlString)&apikey=\(apiKey)")!
        
        // Create a URL session
        let session = URLSession.shared
        
        // Create a data task to fetch the contents of the URL
        let task = session.dataTask(with: whisperAPIURL) { (data, response, error) in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if response is an HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)))
                return
            }
            
            // Check if status code is success (200)
            guard httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "HTTP Error: \(httpResponse.statusCode)", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            // Check if data is available
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            // Convert data to string
            if let text = String(data: data, encoding: .utf8) {
                completion(.success(text))
            } else {
                completion(.failure(NSError(domain: "Failed to convert data to text", code: 0, userInfo: nil)))
            }
        }
        
        // Start the data task
        task.resume()
    }
}
