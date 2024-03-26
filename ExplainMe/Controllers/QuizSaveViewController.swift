//
//  QuizSaveViewController.swift
//  ExplainMe
//
//  Created by Bdriah Talaat on 14/09/1445 AH.
//

import UIKit

class QuizSaveViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var quizSaveTableView: UITableView!
   
    
    //MARK: VARIABLE
    var qeustion :[String] = []
    var answer :[String] = []
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(qeustion)
        
        quizSaveTableView.delegate = self
        quizSaveTableView.dataSource = self
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: false)
    }
    

}
//MARK: EXTINTION
extension QuizSaveViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return qeustion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "question cell", for: indexPath) as! QuizSaveTableViewCell
        let data = qeustion[indexPath.row]
        
        cell.answerTextView.text = answer[indexPath.row]
        cell.questionLabel.text = data
        
        return cell
    }
    
    
}
