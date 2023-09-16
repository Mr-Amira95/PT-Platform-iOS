//
//  QuestionsVC.swift
//  PT_Platform
//
//  Created by Mohammad Jawher on 18/08/2022.
//

import UIKit
import LanguageManager_iOS

class QuestionsVC: UIViewController {
    
    var datalist = [QuestionsM]()
    var array = [[String:Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.shared.currentLanguage == .en{
            imgBack.image = UIImage(named: "btnBack")
        }else{
            imgBack.image = UIImage(named: "btnBackAr")
        }
        if Shared.shared.getusertype() == "Coach"{
            self.navigationController?.navigationBar.isHidden = true
            getQuestiondataInCoach()
            btnDone.isHidden = true
        }else{
            getQuestiondata()
            btnDone.isHidden = false
        }
        
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "QuestionsCell", bundle: nil), forCellReuseIdentifier: "QuestionsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getQuestiondata(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.questionsPage { questions, message, bool   in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = questions
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    func getQuestiondataInCoach(){
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.questionsCoachPage { questions, message, bool   in
            Spinner.instance.removeSpinner()
            if bool{
                self.datalist = questions
                self.setupTableView()
            }else{
                ToastView.shared.short(self.view, txt_msg: message)
            }
        }
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let parameter = ["coach_id" : Shared.shared.getCoachId() ?? 0,
                         "answers" : array] as [String : Any]
        Spinner.instance.showSpinner(onView: view)
        ControllerService.instance.questionsPost(param: parameter) { message, bool in
            Spinner.instance.removeSpinner()
            if bool{
                self.Alert(Message: message)
            }else{
                let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Successfully", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

extension QuestionsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsCell", for: indexPath) as? QuestionsCell
        cell?.setData(data: datalist[indexPath.row])
//        cell?.txtAnswer.text = datalist[indexPath.row].answer
//        cell?.lblQuestion.text = datalist[indexPath.row].question
            cell!.selectionStyle = .none
        if LanguageManager.shared.currentLanguage == .ar{
            cell?.txtAnswer.textAlignment = .right
        }
        
        if Shared.shared.getusertype() == "Coach"{
            cell?.txtAnswer.isEnabled = false
            cell?.txtAnswer.textColor = UIColor(named: "MainColor")
        }else{
            cell?.txtAnswer.isEnabled = true
          
            cell?.txtAnswer.addTarget(self, action: #selector(TextfieldEditAction), for: .editingDidEnd)
        }
        cell?.txtAnswer.tag = indexPath.row
      
//        let obj = ["question_id" :datalist[indexPath.row].question,
//                   "answer" : datalist[indexPath.row].answer]
//        array.append(obj as [String : Any])
            return cell!
    }
    @objc func TextfieldEditAction(sender: UITextField) {
        print(sender.tag)
//        var index = 0
//        array.removeAll()
//        for i in datalist{
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) as? QuestionsCell {
//                let text = sender.text ?? ""
//                cell.txtAnswer.text = sender.text
//                let obj = ["question_id" : i.id,
//                           "answer" : sender.text ?? ""]
//                print(sender.text)
//                if text ?? "" != ""{
//                    array.append(obj)
//                }
//              }
//            index += 1
//        }
        for (index,i) in datalist.enumerated(){
            if index  == sender.tag{
                let indexPath = IndexPath(row:sender.tag, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? QuestionsCell {
                    cell.txtAnswer.text = sender.text
                    datalist[sender.tag].answer = sender.text
                }
                let obj = ["question_id" : i.id,"answer" : sender.text ?? ""]
                array.append(obj)
                break
            }else{
                let indexPath = IndexPath(row:index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? QuestionsCell {
                    cell.txtAnswer.text = i.answer
                }
                let obj = ["question_id" : i.id,"answer" : i.answer ?? ""]
                array.append(obj)
            }

        }
        tableView.reloadData()
    }
}
