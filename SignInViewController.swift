//
//  SignInViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/10/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    
    var ref:FIRDatabaseReference?
    
    
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()
        SignInButton.layer.cornerRadius = 10
        BackButton.layer.cornerRadius = 10

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
   
    @IBAction func didAttemptLogIn(_ sender: UIButton) {
        guard let emailText = username.text else { return }
        guard let passwordText = password.text else { return }
        FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: { (user, error) in
            if let error = error {
                //print("Sign in failed, try again")
                let alert = UIAlertController(title: "Sign in failed, try again", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "SignInToMain", sender: self)
            }
        })
    }
    
    
    @IBAction func BackPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToTick", sender: self)
    }
    
 
    

}
