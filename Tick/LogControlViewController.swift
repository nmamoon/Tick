//
//  LogControlViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 6/1/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class LogControlViewController: UIViewController {
    var ref:FIRDatabaseReference?
    let cUser = FIRAuth.auth()?.currentUser
    @IBOutlet weak var EULALabel: UILabel!

    @IBOutlet weak var YesButton: UIButton!
    
    @IBOutlet weak var NoButton: UIButton!
    
    var tester: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        EULALabel.layer.masksToBounds = true
        EULALabel.layer.cornerRadius = 15
        
        YesButton.layer.cornerRadius = 15
        NoButton.layer.cornerRadius = 15

        
        ref?.child("EULA").observeSingleEvent(of: .value, with: { (snapshot) in
            let info = snapshot.value as? String
            if info != nil {
                
                self.EULALabel.text = info
            }
            
            
            
            
        })
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        ref?.child("EULA").observeSingleEvent(of: .value, with: { (snapshot) in
            let info = snapshot.value as? String
            if info != nil {
                
                self.EULALabel.text = info
            }
            
            
            
            
        })
    }
    
    
    @IBAction func YesPressed(_ sender: UIButton) {
        if tester != nil {
            performSegue(withIdentifier: "EULAToBio", sender: self)
        } else {
            performSegue(withIdentifier: "Accord", sender: self)
        }
        
    }
    
    
    
    @IBAction func NoPressed(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            performSegue(withIdentifier: "Obstinacy", sender: self)
        } catch let signOutError as NSError {
            //print ("Error signing out: \(signOutError)")
        } catch {
            //print("Unknown error.")
        }
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? BioViewController {
            dest.startpic = true
        }
    }
    

}
