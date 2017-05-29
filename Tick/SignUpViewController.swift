//
//  SignUpViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/9/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    var ref:FIRDatabaseReference?
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()
        SignUpButton.layer.cornerRadius = 15
        BackButton.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? BioViewController {
            //dest.DisplayPicture = holderImage
            //dest.imagestored = picholder!
            dest.startpic = true
            //print("YES")
        }
    }
    
    
    @IBAction func didAttemptSignUp(_ sender: UIButton) {
        
        guard let emailtext = email.text else { return }
        guard let passwordtext = password.text else { return }
        guard let nametext = username.text else { return }
        //print("HERE1")
        FIRAuth.auth()?.signIn(withEmail: "banana@gmail.com", password: "banana", completion: { (user, error) in
            if let error = error {
                
            } else {
                
                
                
                
                
                self.ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                    let userdict = snapshot.value as? NSDictionary
                    
                    
                    print("sign out button tapped")
                    let firebaseAuth = FIRAuth.auth()
                    do {
                        try firebaseAuth?.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: \(signOutError)")
                    } catch {
                        print("Unknown error.")
                    }
                    
                    
                    
                    var test = false
                    //print("HERE2")
                    for name in (userdict?.allKeys)! {
                        if name as! String == nametext {
                            test = true
                        }
                    }
                    if test {
                        //print("HERE3")
                        
                        let popup = UIAlertController(
                            title: "Username Taken!",
                            message: "Please choose a different username!",
                            preferredStyle: .alert)
                        
                        let exit = UIAlertAction(title: "OK!", style: .default) {
                            action in self.sOver() }
                        
                        popup.addAction(exit)
                        
                        //print("Well we are here!")
                        
                        self.present(popup, animated:true)
                        
                    } else {
                        //print("HERE4")
                        FIRAuth.auth()?.createUser(withEmail: emailtext, password: passwordtext, completion: { (user, error) in
                            if let error = error {
                                let alert = UIAlertController(title: "Signup failed, try again", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let changeRequest = user!.profileChangeRequest()
                                changeRequest.displayName = nametext
                                changeRequest.commitChanges(completion: { (err) in
                                    if let error = err {
                                        let alert = UIAlertController(title: "Signup failed, try again", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                        //print("here")
                                        self.performSegue(withIdentifier: "FirstPic", sender: self)
                                    }
                                })
                                //                self.ref?.child("Users").childByAutoId().setValue(["Name": name, "Latitude": 0, "Longitude": 0])
                                
                                //print("yes")
                            }})
                    }
                    
                })
                
                
                
                
                
                
                
                
                
                
            }
        })
        
        
        
        
        
        
        
        
    }
    
    
    @IBAction func BackPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToTick", sender: self)
    }
    
    
    func sOver() {
        //viewDidLoad()
        //gameOver = true
    }

}
