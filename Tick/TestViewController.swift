//
//  TestViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/10/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TestViewController: UIViewController {
 
   // var ref:FIRDatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let cUser = FIRAuth.auth()?.currentUser
        //self.ref?.child("Users").child((cUser?.uid)!).setValue(["Name": "hello", "Password": "test"])
        print("yes")

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
