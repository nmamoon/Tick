//
//  FriendBioViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/15/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class FriendBioViewController: UIViewController {

    
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var UpvoteLabel: UILabel!
    
    @IBOutlet weak var RevealLabel: UILabel!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var BioLabel: UILabel!
    
    var testimage: UIImage?
    var nametext: String?
    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        NameLabel.text = nametext
        
        UpvoteLabel.layer.masksToBounds = true
        UpvoteLabel.layer.cornerRadius = 15
        
        RevealLabel.layer.masksToBounds = true
        RevealLabel.layer.cornerRadius = 15
        
        ProfilePic.layer.masksToBounds = true
        ProfilePic.layer.cornerRadius = 15
        ProfilePic.image = testimage
        
        BioLabel.layer.masksToBounds = true
        BioLabel.layer.cornerRadius = 15
        
        if nametext == "nmamoon" {
            NameLabel.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
            UpvoteLabel.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
            RevealLabel.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
            BioLabel.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
        }
        
        ref?.child("Users").child((nametext)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                }
                let biotext = usersDict?["Biography"] as! String
                self.BioLabel.text = biotext
                
                //self.EditBio.text = text
                
                
                
                
                
                
            }
            
            
            
        })
        
        var count = 0
        //self.UpvoteCount.text = "0 UPVOTES"
        ref?.child("CommentsCount").child(nametext!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                    
                    count += 1
                    
                    
                    
                }
                if count == 1 {
                    self.UpvoteLabel.text = "1 Comment"
                } else {
                    self.UpvoteLabel.text = "\(count) Comments"
                }
                
            }
            
            
            
        })
        var counter = 0
        ref?.child("Reveals").child(nametext!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                    
                    counter += 1
                    
                    
                    
                }
                if counter == 1 {
                    self.RevealLabel.text = "1 Reveal"
                } else {
                    self.RevealLabel.text = "\(counter) Reveals"
                }            }
            
            
            
        })

        // Do any additional setup after loading the view.
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
