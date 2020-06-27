//
//  detailViewController.swift
//  practice
//
//  Created by 柴田将吾 on 2020/06/22.
//  Copyright © 2020 柴田将吾. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    
    @IBOutlet weak var englishLabel: UILabel!
    
    @IBOutlet weak var japaneseLabel: UILabel!
    
    var englishString = String()
    
    var japaneseString = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        englishLabel.text = englishString
        japaneseLabel.text = japaneseString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
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
