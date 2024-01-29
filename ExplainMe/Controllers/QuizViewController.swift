//
//  QuizViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 21/06/1445 AH.
//

import UIKit

class QuizViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var quizTableView: UITableView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTableView.dataSource = self
        quizTableView.delegate = self
        
        saveButton.setCircle(View: saveButton, value: 5)
        submitButton.setCircle(View: submitButton, value: 5)
    }
    

    
    
    //MARK: ACTIONS
    
    @IBAction func backButton(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(identifier: "video screen") as! VideoViewController
        
        navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    
    @IBAction func submitButton(_ sender: Any) {
    }
    
}

//MARK: EXTENTION
extension QuizViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "question cell", for: indexPath) as! QuizTableViewCell
        cell.qustionLabel.text = "Question 1"
        cell.answerTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
