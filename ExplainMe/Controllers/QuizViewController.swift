//
//  QuizViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit
import NVActivityIndicatorView

class QuizViewController: UIViewController {

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
    var question:[String] = []
    var answer:[String] = [" jbjbjbjjjb.", " A family tree is a real-life example of a tree data structure.", " File explorers, databases, domain name servers, and the HTML document object model."," jjjnln node.", " Leaf nodes.", " Yes, a node can be both a parent and a child if it has both incoming and outgoing edges.", "- The depth of a node is the number of edges below the root node.", "- jjbjbjbj", "- A subtree is a smaller tree held within a larger tree."]
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTableView.dataSource = self
        quizTableView.delegate = self
        
        saveButton.setCircle(View: saveButton, value: 5)
        submitButton.setCircle(View: submitButton, value: 5)
        
        correctAnswerView.setCircle(View: correctAnswerView, value: 20)
        correctAnswerView.isHidden = true
        
        loaderView.startAnimating()
        OpenAi.tranciption(file: "") { response in
            OpenAi.quiz(text: response) { response in
                
                let responseString = response as! String
                let words = responseString.split(separator: "\n").map { String($0) }
                self.question.append(contentsOf: words)
                
                print(self.question)
                self.quizTableView.reloadData()
                
                self.loaderView.stopAnimating()
            }
        }
    }
    

    
    
    //MARK: ACTIONS
    
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        question.removeAll()
        navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    
    @IBAction func closeButton(_ sender: Any) {
        correctAnswerView.isHidden = true
        
        let alert = UIAlertController(title: "Try Quiz Again", message: "Do you want try quiz again ?" , preferredStyle: .alert)
         let noAction = UIAlertAction(title: "No", style: .default)
         let yesAction = UIAlertAction(title: "Yes", style: .default){ _ in
             
             self.answer.removeAll()
             self.quizTableView.reloadData()
         }
         
         alert.addAction(yesAction)
         alert.addAction(noAction)
         self.present(alert, animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        loaderView.startAnimating()
        OpenAi.tranciption(file: "") { response in
            
            OpenAi.answer(text: "Are these correct answers \(self.answer) to these questions \(self.question) if were answers not correct then correct the wrong answer") { response in
                
                self.loaderView.stopAnimating()
                
                self.correctAnswerView.isHidden = false
                self.correctAnswerTextView.text =  response as! String
                //"Correct Answer\n"
            }
        }
    }
    
}

//MARK: EXTENTION
extension QuizViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "question cell", for: indexPath) as! QuizTableViewCell
        let data = question[indexPath.row]
        
        cell.qustionLabel.text = data
        answer.append(cell.answerTextView.text!)
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }*/
    
}
