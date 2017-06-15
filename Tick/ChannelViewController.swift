//
//  ChannelViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/23/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class ChannelViewController: UIViewController {

    @IBOutlet weak var ChannelText: UITextField!
    
    @IBOutlet weak var UpdateButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var InfoLabel: UILabel!
     var ref:FIRDatabaseReference?
     let cUser = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        UpdateButton.layer.masksToBounds = true
        UpdateButton.layer.cornerRadius = 10
        
        InfoLabel.layer.masksToBounds = true
        InfoLabel.layer.cornerRadius = 15
        
        CancelButton.layer.masksToBounds = true
        CancelButton.layer.cornerRadius = 10
        
        ChannelText.layer.masksToBounds = true
        ChannelText.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CancelPressed(_ sender: UIButton) {
        ChannelText.endEditing(true)
        ChannelText.text = ""
    }
    @IBAction func UpdatePressed(_ sender: UIButton) {
        if ChannelText.text != "" {
            let test = ChannelText.text!
            if test != "Comments" && test != "Votes" && test != "Reveals" && test != "Users" && test != "CommentsCount" && test != "Postcount" && test != "Info" && test != "Reports" && test != "Decider" {
                channel = test
         self.ref?.child("Channel").child((cUser?.displayName)!).setValue(test)
            ChannelText.endEditing(true)
            ChannelText.text = ""
                performSegue(withIdentifier: "FinishedChanging", sender: self)
                
            }
        }
        
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
