//
//  BioViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/18/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class BioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var LogOutButton: UIButton!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var VoteLabel: UILabel!
    
    @IBOutlet weak var RevealLabel: UILabel!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var EditBio: UITextView!
    
    @IBOutlet weak var TestImage: UIImageView!
    
    @IBOutlet weak var PicButton: UIButton!
    
    @IBOutlet weak var UpdateButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    var tabBarItem1: UITabBarItem = UITabBarItem()
    var tabBarItem2: UITabBarItem = UITabBarItem()
    var tabBarItem3: UITabBarItem = UITabBarItem()
    var tabBarItem4: UITabBarItem = UITabBarItem()
    var ref:FIRDatabaseReference?
    var startpic: Bool?
    var holder: String?
    var typing = false
    var usepic = false
    var picholder:UIImage?
    var holdertext: String?
    let cUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        
        VoteLabel.layer.masksToBounds = true
        VoteLabel.layer.cornerRadius = 15
        
        RevealLabel.layer.masksToBounds = true
        RevealLabel.layer.cornerRadius = 15
        
        ProfilePic.layer.masksToBounds = true
        ProfilePic.layer.cornerRadius = 15
        
        EditBio.layer.masksToBounds = true
        EditBio.layer.cornerRadius = 15
        
        TestImage.layer.masksToBounds = true
        TestImage.layer.cornerRadius = 15
        
        PicButton.layer.cornerRadius = 15
        LogOutButton.layer.cornerRadius = 15
        UpdateButton.layer.cornerRadius = 15
        CancelButton.layer.cornerRadius = 15
        
       
        NameLabel.text = cUser?.displayName
        EditBio.delegate = self
        
        if startpic != nil {
            let popup = UIAlertController(
                title: "Please update your biography and picture!",
                message: "Tap the box to write your bio, then tap the pic button to add a picture! Finally, press update!",
                preferredStyle: .alert)
            
            let exit = UIAlertAction(title: "OK!", style: .default) {
                action in self.sOver() }
            
            popup.addAction(exit)
            
            //print("Well we are here!")
            
            self.present(popup, animated:true)
            
            //print("We finished that!")

        }
        
        //usepic = false

        // Do any additional setup after loading the view.
    }
    
    func sOver() {
        //viewDidLoad()
        //gameOver = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        if let tabArray = tabBarControllerItems {
            tabBarItem1 = tabArray[0]
            tabBarItem2 = tabArray[1]
            tabBarItem3 = tabArray[2]
            tabBarItem4 = tabArray[3]
            
            tabBarItem1.isEnabled = false
            tabBarItem2.isEnabled = false
            tabBarItem3.isEnabled = false
            tabBarItem4.isEnabled = false
        }
        let when = DispatchTime.now() + 0.3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            //print("DISPATCH")
            self.tabBarItem1.isEnabled = true
            self.tabBarItem2.isEnabled = true
            self.tabBarItem3.isEnabled = true
            self.tabBarItem4.isEnabled = true
            //self.Comments.reloadData()
        }
        
        
        ref?.child("Users").child((cUser?.displayName)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                }
                let text = usersDict?["Biography"] as! String
                self.holdertext = text
                
                self.EditBio.text = text
                if let link = usersDict?["Picture"] as? String {
                    let url = URL.init(string: link)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.ProfilePic.image = UIImage(data: data!)
                        }
                    }).resume()
                }
                
              
                
                
                
            }
            
            
            
        })
        
        var count = 0
        //self.UpvoteCount.text = "0 UPVOTES"
        ref?.child("CommentsCount").child((cUser?.displayName!)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                    
                    count += 1
                    
                    
                    
                }
                if count == 1 {
                    self.VoteLabel.text = "1 Comment"
                } else {
                    self.VoteLabel.text = "\(count) Comments"
                }
                
            }
            
            
            
        })
        var counter = 0
        ref?.child("Reveals").child((cUser?.displayName!)!).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //PostBox.text = ""
        if startpic != nil {
            EditBio.text = ""
        }
        
        if !typing {
            EditBio.becomeFirstResponder()
            //print("here")
            UpdateButton.backgroundColor = UIColor.green
            CancelButton.backgroundColor = UIColor.green
            PicButton.backgroundColor = UIColor.green
            typing = true
        }
        else {
            //print("here")
            EditBio.becomeFirstResponder()
        }
        
    }
    
    @IBAction func CancelPressed(_ sender: UIButton) {
        
        if let sample = holdertext {
            EditBio.text = sample
        } else {
            EditBio.text = ""
        }
        
        EditBio.endEditing(true)
        
        UpdateButton.backgroundColor = EditBio.backgroundColor
        CancelButton.backgroundColor = EditBio.backgroundColor
        PicButton.backgroundColor = EditBio.backgroundColor
        //print(" " + String(typing) + " why")
        typing = false
        //PostBox.becomeFirstResponder()
        usepic = false
        picholder = UIImage()
        TestImage.image = nil
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TickViewController {
            print("EXECUTED")
            self.navigationController?.setNavigationBarHidden(true, animated: false)
           self.tabBarController?.tabBar.isHidden = true
            dest.navigationController?.setNavigationBarHidden(true, animated: false)
            dest.tabBarController?.tabBar.isHidden = true
            
        }
      
    }
    
    @IBAction func AddPic(_ sender: UIButton) {
        let holder = EditBio.text
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated:true, completion:nil)
        usepic = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        usepic = false
        picholder = UIImage()
        TestImage.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedimage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedimage = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedimage = originalImage
            
        }
        if let newpic = selectedimage {
            picholder = newpic
            TestImage.image = newpic
        } else {
            picholder = UIImage()
            TestImage = UIImageView()
        }
        //print(info)
        usepic = true
        if holder != nil {
            EditBio.text = holder
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func UpdatePressed(_ sender: UIButton) {
        
        let cUser = FIRAuth.auth()?.currentUser
        let mname = cUser?.displayName
        let posttext = EditBio.text
        //self.ref?.child("Users").child((cUser?.uid)!).childByAutoId().setValue(posttext)
        //let form = DateFormatter()
        //let dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        //form.dateFormat = dateFormat
       // let date = form.string(from: Date())
        if usepic {
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child(imageName)
            if let upData = UIImagePNGRepresentation(picholder!) {
                storageRef.put(upData, metadata: nil, completion:
                    {(metadata, error) in
                        if error != nil {
                            print(error!)
                        }
                        //print(metadata!)
                        let url = metadata?.downloadURL()?.absoluteString
                        self.ref?.child("Users").child(mname!).child("Picture").setValue(url)
                        self.ref?.child("Users").child(mname!).child("Biography").setValue(posttext)
                        
                        if self.startpic != nil {
                            
                            newUser = true
                            self.performSegue(withIdentifier: "ToMain", sender: self)
                            
                        }
                        //self.ref?.child("Posts").childByAutoId().setValue(["Name": cUser?.displayName!, "Date": date, "Text": posttext, "URL": url])
                        self.viewDidAppear(true)
                        
                        
                })
            }
            // let upData = UIImagePNGRepresentation(picholder!)
            
            
        } else {
            self.ref?.child("Users").child(mname!).child("Biography").setValue(posttext)
        }
        
        EditBio.text = ""
        EditBio.endEditing(true)
        UpdateButton.backgroundColor = EditBio.backgroundColor
        CancelButton.backgroundColor = EditBio.backgroundColor
        PicButton.backgroundColor = EditBio.backgroundColor
        //print(" " + String(typing) + " why")
        viewDidAppear(true)
        
        
        typing = false
        usepic = false
        picholder = UIImage()
        TestImage.image = nil
        viewDidAppear(true)
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        print("sign out button tapped")
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
              performSegue(withIdentifier: "ToMain", sender: self)
        } catch let signOutError as NSError {
            //print ("Error signing out: \(signOutError)")
        } catch {
            //print("Unknown error.")
        }
      
    
    }
    
    
    

}
