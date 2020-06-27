//
//  HomeViewController.swift
//  practice
//
//  Created by 柴田将吾 on 2020/06/19.
//  Copyright © 2020 柴田将吾. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var englishSentence = String()
    var japaneseSentence = String()
    var sentencesArray = [Sentence]()
    var uid = Auth.auth().currentUser?.uid
    var Keys = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        fetchData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentencesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let englishLabel = cell.viewWithTag(1) as! UILabel
        englishLabel.text = sentencesArray[indexPath.row].EnglishString
        
        let japaneseLabel = cell.viewWithTag(2) as! UILabel
        japaneseLabel.text = sentencesArray[indexPath.row].JapaneseString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //セルを削除
        sentencesArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        //firebaseからデータを削除
        Database.database().reference().child(uid!).child(Keys[indexPath.row]).removeValue()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(identifier: "detail") as! detailViewController
        
        detailVC.englishString = sentencesArray[indexPath.row].EnglishString
        detailVC.japaneseString = sentencesArray[indexPath.row].JapaneseString
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func fetchData(){
        let ref = Database.database().reference().child(uid!).observe(.value) { (snapShot) in
        self.sentencesArray.removeAll()
        self.Keys.removeAll()
        if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
            
            for snap in snapShot{
                if let data = snap.value as? [String:String]{
                    let english = data["English"]
                    let japanese = data["Japanese"]
                    self.Keys.append(snap.key)
                    self.sentencesArray.append(Sentence(EnglishString: english!, JapaneseString: japanese!))
                }
            }
            self.tableView.reloadData()
        }
        
        }
        
        
    }
    

}
