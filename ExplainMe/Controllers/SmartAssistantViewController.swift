//
//  SmartAssistantViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit

class SmartAssistantViewController: UIViewController {

    //MARK: OUTLETS

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var methodView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var fromKnowlegeButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fromVideoButton: UIButton!
   
    //MARK: VARIABLES
    var message:[String]? = []
    var index = 0
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextView.setCircle(View: messageTextView, value: 5)
        methodView.setCircle(View: methodView, value: 12)
        imageView.setCircle(View: imageView, value: 2)
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        messageTextView.delegate = self

        if messageTextView.text == ""{
            sendButton.isEnabled = false
            chatTableView.isHidden = true
        }
        
    }
    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        navigationController?.popViewController(animated: false)

    }
    // have to edit
    @IBAction func answerButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "From video"{
            
            fromVideoButton.setImage(.init(systemName: "checkmark.circle"), for: .normal)
            
        }
        else if  sender.titleLabel?.text == "From my Knowlege"{
            fromKnowlegeButton.setImage(.init(systemName: "checkmark.circle"), for: .normal)
            
        }
        else if  sender.titleLabel?.text == "Both from video and my Knowlege"{
            bothButton.setImage(.init(systemName: "checkmark.circle"), for: .normal)
            
        }else{
            print(sender.titleLabel?.text)
        }
        fromVideoButton.isEnabled = false
        fromKnowlegeButton.isEnabled = false
        bothButton.isEnabled = false
        
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        index += 1
        chatTableView.isHidden = false
        message?.append(messageTextView.text)
        //messageTextView.text = ""
        chatTableView.reloadData()
        sendButton.isEnabled = false
        messageTextView.text = ""
    }
    
    
    
}
//MARK: EXTENTION
extension SmartAssistantViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! ChatTableViewCell
        
        let data = message![indexPath.row]
       
        cell.imagView.setCircle(View: cell.imagView, value: 2)
        cell.viewMessage.setCircle(View: cell.viewMessage, value: 12)
        cell.messageLabel.text = data
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70//UITableView.automaticDimension
    }
    
}
//MARK: EXTENTION

extension SmartAssistantViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if messageTextView.text.isEmpty || messageTextView.text == "" {
            
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
    }
   
}
