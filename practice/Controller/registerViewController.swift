//
//  registerViewController.swift
//  practice
//
//  Created by 柴田将吾 on 2020/06/20.
//  Copyright © 2020 柴田将吾. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.text = emailTextField.text
        passwordTextField.text = passwordTextField.text
        self.view.endEditing(true)
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil{
                print(error)
            }else{
                print("ユーザーの作成が成功しました！")
                
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
