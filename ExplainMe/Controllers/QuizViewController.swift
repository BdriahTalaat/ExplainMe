//
//  QuizViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import NVActivityIndicatorView
import SwiftEntryKit

@available(iOS 16.0, *)
class QuizViewController: UIViewController, UITextViewDelegate {

    //MARK: OUTLETS
    @IBOutlet weak var correctAnswerView: UIView!{
        didSet{
            correctAnswerView.layer.shadowColor = UIColor.gray.cgColor // color shadow
            correctAnswerView.layer.shadowOpacity = 0.3 // alpha shadow
            correctAnswerView.layer.shadowOffset = CGSize(width: 15, height: 10)
            correctAnswerView.layer.shadowRadius = 20
            
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var correctAnswerTextView: UITextView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var quizTableView: UITableView!
    
    //MARK: VARIABLE
    var quizDelegate:QuizVideoDelegat?
    var video:Video?
    
    var videoTitle = ""
    var videoURL :String = ""
    var quastionNumber = ""
    var transcribe = ""
    var sammary:String?
    var question:[String] = []
    
    var answers: [String] = []

    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTableView.dataSource = self
        quizTableView.delegate = self
        
        saveButton.setCircle(View: saveButton, value: 5)
        submitButton.setCircle(View: submitButton, value: 5)
        
        saveButton.isEnabled = false
        submitButton.isEnabled = false
        
        correctAnswerView.setCircle(View: correctAnswerView, value: 20)
        correctAnswerView.isHidden = true
        
        loaderView.startAnimating()
        OpenAi.quiz(text: transcribe, number: quastionNumber) { response in
            
            //self.question.removeAll()
            let responseString = response as! String
            let words = responseString.split(separator: "\n").map { String($0) }
            self.question.append(contentsOf: words)
            
            //print(self.question)
            self.quizTableView.reloadData()
            
            self.saveButton.isEnabled = true
            self.loaderView.stopAnimating()
        }
        
    }
    

    
    
    //MARK: ACTIONS
    
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        //vc.quiz = self.question
        
        navigationController?.popViewController(animated: false)
        //present(vc, animated: false)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "summary screen") as! SummaryViewController
        
        quizDelegate?.didSelectQuizDelegate(quize: self.question, answer: self.answers)
        
        
        var videoData = Video(summary: self.sammary, quiz: self.question, answer:self.answers, videoURL: self.videoURL)
        
        AppManager.shared.add1(summary: videoData.summary, quiz: videoData.quiz, videoURL: videoData.videoURL, answer: videoData.answer, videoTitle: videoTitle) { [self] response in
            
            let alert = UIAlertController(title: "Success", message: "The Quiz is saved" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
             print(response)
            
             alert.addAction(okAction)
             self.present(alert, animated: true)
            
        }
        
        
        
    
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        correctAnswerView.isHidden = true
        
        let alert = UIAlertController(title: "Try Quiz Again", message: "Do you want try quiz again ?" , preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default){ [self]_ in
            
            let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
            navigationController?.popViewController(animated: false)
        }
         let yesAction = UIAlertAction(title: "Yes", style: .default){ _ in
             
             self.answers.removeAll()
             self.quizTableView.reloadData()
         }
         
         alert.addAction(yesAction)
         alert.addAction(noAction)
         self.present(alert, animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        loaderView.startAnimating()
            
        OpenAi.answer(text: "Are these correct answers \(self.answers) to these questions \(self.question) if were answers not correct then correct the wrong answer and give me mark ") { response in
            
            self.loaderView.stopAnimating()
            
            self.correctAnswerView.isHidden = false
            self.correctAnswerTextView.text =  response as! String
            //"Correct Answer\n"
            
        }
    }
    
    
}

//MARK: EXTENTION
@available(iOS 16.0, *)
extension QuizViewController:UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question cell", for: indexPath) as! QuizTableViewCell
        let data = question[indexPath.row]
        
        cell.answerTextView.text = ""
        cell.qustionLabel.text = data
        
        if indexPath.row < answers.count  {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }

        
        cell.textChanged = { [weak self] text in
            self?.updateAnswer(at: indexPath.row, with: text)
        }
        
        return cell
    }

    func updateAnswer(at index: Int, with text: String) {
       
        if index < answers.count {
            answers[index] = text
        } else {
            answers.append(text)
        }
    }
    
    
}

//MARK: EXTENTION
@available(iOS 16.0, *)
extension QuizViewController : UITextViewDelegate{
   
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        
        view.endEditing(true)
        
        return true
    }
  
}


//MARK: PROTOCAL
protocol QuizVideoDelegat{
    func didSelectQuizDelegate(quize:[String]?,answer:[String]?)
}


