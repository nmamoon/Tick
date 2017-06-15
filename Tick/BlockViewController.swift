//
//  BlockViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 6/3/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class BlockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var enterBody: UITextField!
    
    
    @IBOutlet weak var blockButton: UIButton!
    
    
    @IBOutlet weak var unBlockButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var MyTable: UITableView!
    
    
    @IBOutlet weak var blockLab: UILabel!
    
    var ref:FIRDatabaseReference?
    let cUser = FIRAuth.auth()?.currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        self.ref?.child("Users").child((cUser?.displayName)!).child("Blocks").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                blockedUsers = [String]()
                for vall in (usersDict?.allKeys)! {
                    blockedUsers.append(vall as! String)
                    
                }
            } else {
                //cell.UpvoteLabel.text = "0 UPVOTES"
            }
            
            
            
        })
        mainLabel.layer.masksToBounds = true
        mainLabel.layer.cornerRadius = 15
        
        enterBody.layer.masksToBounds = true
        enterBody.layer.cornerRadius = 15
        
        blockLab.layer.masksToBounds = true
        blockLab.layer.cornerRadius = 15
        
        blockButton.layer.cornerRadius = 15
        unBlockButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15

        MyTable.delegate = self
        MyTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func blockPressed(_ sender: UIButton) {
        print("yes1")
        if enterBody.text != nil {
            //print(enterBody.text!)
            //print("yes2")
            //print((cUser?.displayName)!)
                self.ref?.child("Users").child((cUser?.displayName)!).child("Blocks").child(enterBody.text!).setValue("BLOCKED")
            //print("done")
            enterBody.endEditing(true)
            enterBody.text = ""
            
        }
        viewDidAppear(true)
    }
    
    
    @IBAction func unBlockPressed(_ sender: UIButton) {
        if enterBody.text != nil {
            self.ref?.child("Users").child((cUser?.displayName)!).child("Blocks").child(enterBody.text!).removeValue()
            enterBody.endEditing(true)
            enterBody.text = ""
        }
        viewDidAppear(true)
    }
    
    
 
    @IBAction func cancelPressed(_ sender: UIButton) {
        enterBody.endEditing(true)
        enterBody.text = ""
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTable.dequeueReusableCell(withIdentifier: "celltype") as! BlockCellTableViewCell
        cell.name.text = blockedUsers[indexPath.row]
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref?.child("Users").child((cUser?.displayName)!).child("Blocks").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                blockedUsers = [String]()
                for vall in (usersDict?.allKeys)! {
                    blockedUsers.append(vall as! String)
                    
                }
                self.MyTable.reloadData()
            } else {
                //cell.UpvoteLabel.text = "0 UPVOTES"
            }
            
            
            
        })
        //MyTable.reloadData()
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
