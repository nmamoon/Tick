//
//  InfoViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/19/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class InfoViewController: UIViewController {

    @IBOutlet weak var MyLabel: UILabel!
   
    @IBOutlet weak var InfoLabel: UILabel!
    
     var ref:FIRDatabaseReference?
    let cUser = FIRAuth.auth()?.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        InfoLabel.layer.masksToBounds = true
        InfoLabel.layer.cornerRadius = 15
        
        MyLabel.layer.masksToBounds = true
        MyLabel.layer.cornerRadius = 15
        
        
        ref?.child("Info").observeSingleEvent(of: .value, with: { (snapshot) in
            let info = snapshot.value as? String
            if info != nil {
                
                self.InfoLabel.text = info
            }
       
               
            
            
        })
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref?.child("Info").observeSingleEvent(of: .value, with: { (snapshot) in
            let info = snapshot.value as? String
            if info != nil {
                
                self.InfoLabel.text = info
            }
            
            
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
