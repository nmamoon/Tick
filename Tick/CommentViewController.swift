//
//  CommentViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/20/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class CommentViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var CommentBox: UITextView!
    
    @IBOutlet weak var PostButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    var hasposted = false
    var imagepost: Bool?
    var basicpost: Bool?
    var typing: Bool?
    var postid: String?
    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CommentBox.layer.masksToBounds = true
        CommentBox.layer.cornerRadius = 15
        
        PostButton.layer.cornerRadius = 15
        CancelButton.layer.cornerRadius = 15
        
        CommentBox.delegate = self
        typing = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //PostBox.text = ""
        if !typing! {
            CommentBox.becomeFirstResponder()
            //print("here")
            PostButton.backgroundColor = UIColor.green
            CancelButton.backgroundColor = UIColor.green
            typing = true
        }
        else {
            //print("here")
            CommentBox.becomeFirstResponder()
        }
        
    }
    
    
    @IBAction func CancelPressed(_ sender: UIButton) {
        
        CommentBox.text = ""
        CommentBox.endEditing(true)
        
        PostButton.backgroundColor = CommentBox.backgroundColor
        CancelButton.backgroundColor = CommentBox.backgroundColor
        typing = false

    }
    
    
    @IBAction func PostPressed(_ sender: UIButton) {
        
        if !hasposted {
            let username = FIRAuth.auth()?.currentUser?.displayName
            let comtext = CommentBox.text
            self.ref?.child("Comments").child(postid!).child(username!).child("Post").setValue(comtext)
            
                self.ref?.child("CommentsCount").child(username!).child(postid!).setValue("commented")
            CommentBox.text = ""
            CommentBox.endEditing(true)
            PostButton.backgroundColor = CommentBox.backgroundColor
            CancelButton.backgroundColor = CommentBox.backgroundColor
            typing = false
            hasposted = true
        } else {
            CommentBox.text = ""
            CommentBox.endEditing(true)
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
