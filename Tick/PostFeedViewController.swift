//
//  PostFeedViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/12/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class PostFeedViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let cUser = FIRAuth.auth()?.currentUser
    var ref:FIRDatabaseReference?
    var initialLoad = true
    var picholder:UIImage?
    var startbool: Bool?
    var usepic = false
    var tabBarItem1: UITabBarItem = UITabBarItem()
    var tabBarItem2: UITabBarItem = UITabBarItem()
    var tabBarItem3: UITabBarItem = UITabBarItem()
    var tabBarItem4: UITabBarItem = UITabBarItem()
    
    @IBOutlet weak var ChannelTag: UILabel!
    
    
    
    @IBOutlet weak var CancelPic: UIButton!
    
    
    @IBOutlet weak var TestImage: UIImageView!
    
    @IBOutlet weak var PostBox: UITextView!
    
    @IBOutlet weak var PostButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    @IBOutlet weak var PostTable: UITableView!
    
    
    @IBOutlet weak var AddPic: UIButton!
    
    var typing = false
    var TableData = [[String]]()
    
    
    
    //prepare for segue
    var nameprep: String?
    var contentprep: String?
    var dateprep: String?
    var idprep: String?
    var imageprep: UIImage?
    var profileprep: UIImage?
    var waiting = false
    
    
    
    override func viewDidLoad() {
        
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
        
        self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.displayName)!).child("Hidings").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                hidePosts = [String]()
                for vall in (usersDict?.allKeys)! {
                    hidePosts.append(vall as! String)
                    
                }
                //self.performSegue(withIdentifier: "ToMain", sender: self)
                //self.MyTable.reloadData()
            } else {
                //cell.UpvoteLabel.text = "0 UPVOTES"
            }
            
            
            
        })
        
        
        
        
        
        
        super.viewDidLoad()
        PostButton.layer.cornerRadius = 15
        CancelButton.layer.cornerRadius = 15
        PostBox.layer.cornerRadius = 15
        AddPic.layer.cornerRadius = 15
        CancelPic.layer.cornerRadius = 15
        TestImage.layer.masksToBounds = true
        TestImage.layer.cornerRadius = 7
        ChannelTag.layer.masksToBounds = true
        ChannelTag.layer.cornerRadius = 15
        PostBox.delegate = self
        PostTable.dataSource = self
        PostTable.delegate = self
        
        if newUser == true {
            newUser = false
            let popup = UIAlertController(
                title: "Welcome to the feed!",
                message: "Here you can observe, vote, and comment on all the posts in your channel. The current channel is Default. To change channels, enter the desired channel using the button in the tab-bar.",
                preferredStyle: .alert)
            
            let exit = UIAlertAction(title: "OK!", style: .default) {
                action in self.sOver() }
            
            popup.addAction(exit)
            
            //print("Well we are here!")
            
            self.present(popup, animated:true)
        }
        
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
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            //print("DISPATCH")
            self.tabBarItem1.isEnabled = true
            self.tabBarItem2.isEnabled = true
            self.tabBarItem3.isEnabled = true
            self.tabBarItem4.isEnabled = true
            //self.Comments.reloadData()
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        ChannelTag.font = UIFont.boldSystemFont(ofSize: 14.0)
        ChannelTag.text = channel
        self.TableData = [[String]]()
        ref?.child(channel).child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print(vall)
                    let val = usersDict?[vall]
                    let dict = val as! NSDictionary
                    let name = dict["Name"]!
                    let date = dict["Date"]!
                    let text = dict["Text"]!
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
                    let newdate = dateFormatter.date(from: date as! String)!
                    let secondsSincePosted = -(newdate.timeIntervalSinceNow)
                    
                    
                    if secondsSincePosted > (48*3600) {
                        
                        self.ref?.child(channel).child("Posts").child(vall as! String).removeValue()
                        self.ref?.child(channel).child("Votes").child(vall as! String).removeValue()
                        self.ref?.child("Comments").child(vall as! String).removeValue()
                        
                    } else if secondsSincePosted > (47*3600){
                    
                        self.ref?.child("Comments").child(vall as! String).removeValue()
                    
                    
                    
                    } else  if (blockedUsers.contains(name as! String)) || (hidePosts.contains(vall as! String)) {
                    
                    
                    } else {
                        if let url = dict["URL"] {
                            self.TableData.append([name as! String, date as! String, text as! String, url as! String, vall as! String])
                        } else {
                            self.TableData.append([name as! String, date as! String, text as! String, vall as! String])
                        }
                        //print(name)
                        //print(date)
                        //print(text)
                      
                        //print("y")
                        //print(self.TableData.count)
                        self.TableData.sort {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
                            let firstdate = dateFormatter.date(from: $0[1])!
                            let seconddate = dateFormatter.date(from: $1[1])!
                            
                            return (-(firstdate.timeIntervalSinceNow)) < (-(seconddate.timeIntervalSinceNow))
                        }
                        //self.PostTable.reloadData()
                        //print("n")
                        
                    }
                    
                    
                    
                }
                self.PostTable.reloadData()
            }
            
        })
        //print(TableData.count)
        PostTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //PostBox.text = ""
        if !typing {
            PostBox.becomeFirstResponder()
            //print("here")
            PostButton.backgroundColor = UIColor.green
            CancelButton.backgroundColor = UIColor.green
            AddPic.backgroundColor = UIColor.green
            typing = true
        }
        else {
            //print("here")
            PostBox.becomeFirstResponder()
        }
        
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? BasicPostViewController {
            //dest.DisplayPicture = holderImage
            //dest.imagestored = picholder!
            dest.namelab = nameprep
            dest.idlab = idprep
            dest.conlab = contentprep
            dest.datelab = dateprep
            dest.profImage = profileprep
            
            
            
        }
        if let dest = segue.destination as? ImagePostViewController {
            //dest.DisplayPicture = holderImage
            //dest.imagestored = picholder!
            dest.namelab = nameprep
            dest.idlab = idprep
            dest.conlab = contentprep
            dest.datelab = dateprep
            dest.conimage = imageprep
            dest.profImage = profileprep
            
            
        }
        if let dest = segue.destination as? TickViewController {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true

        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 


    
    @IBAction func CancelPressed(_ sender: UIButton) {
        PostBox.text = ""
        PostBox.endEditing(true)
        
        PostButton.backgroundColor = PostBox.backgroundColor
        CancelButton.backgroundColor = PostBox.backgroundColor
        AddPic.backgroundColor = PostBox.backgroundColor
        //print(" " + String(typing) + " why")
        typing = false
        //PostBox.becomeFirstResponder()
        usepic = false
        picholder = UIImage()
        TestImage.image = nil
    }
    
    
    @IBAction func SendPressed(_ sender: Any) {
        
        print("yes1")
        print(waiting)
        if !waiting {
            print("yes2")
            
            let cUser = FIRAuth.auth()?.currentUser
            let posttext = PostBox.text
            //self.ref?.child("Users").child((cUser?.uid)!).childByAutoId().setValue(posttext)
            let form = DateFormatter()
            let dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            form.dateFormat = dateFormat
            let date = form.string(from: Date())
            if usepic {
                
                let imageName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child(imageName)
                if let upData = UIImagePNGRepresentation(picholder!) {
                    storageRef.put(upData, metadata: nil, completion:
                        {(metadata, error) in
                            if error != nil {
                                //print(error!)
                            }
                            //print(metadata!)
                            let url = metadata?.downloadURL()?.absoluteString
                            self.ref?.child(channel).child("Posts").childByAutoId().setValue(["Name": cUser?.displayName!, "Date": date, "Text": posttext, "URL": url])
                            self.viewDidAppear(true)
                            
                            
                    })
                }
                // let upData = UIImagePNGRepresentation(picholder!)
                
                
            } else {
                self.ref?.child(channel).child("Posts").childByAutoId().setValue(["Name": cUser?.displayName!, "Date": date, "Text": posttext])
                
            }
            
            PostBox.text = ""
            PostBox.endEditing(true)
            PostButton.backgroundColor = PostBox.backgroundColor
            CancelButton.backgroundColor = PostBox.backgroundColor
            AddPic.backgroundColor = PostBox.backgroundColor
            //print(" " + String(typing) + " why")
            viewDidAppear(true)
            
            
            typing = false
            usepic = false
            picholder = UIImage()
            TestImage.image = nil
            waiting = true
            let when2 = DispatchTime.now() + 10 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when2) {
                //print("DISPATCH")
                //self.Comments.reloadData()
                self.waiting = false
            }

            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("HEREEE")
        //print(TableData[indexPath.row].count)
        //print("HEREE")
        
        if indexPath.row > TableData.count || TableData[indexPath.row].count < 3 {
            performSegue(withIdentifier: "Safety", sender: self)
        }
        
        let name = TableData[indexPath.row][0]
        let date = TableData[indexPath.row][1]
        let content = TableData[indexPath.row][2]
        if TableData[indexPath.row].count == 4 {
            let cell = PostTable.dequeueReusableCell(withIdentifier: "newcell") as! BasicPostCell
            
            ref?.child("Users").child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                let usersDict = snapshot.value as? NSDictionary
                
                if usersDict != nil {
                    for vall in (usersDict?.allKeys)! {
                        //print("HOKUM")
                        //print(vall)
                        
                    }
                    
                    if let link = usersDict?["Picture"] as? String {
                        let url = URL.init(string: link)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            DispatchQueue.main.async {
                                cell.Pic.image = UIImage(data: data!)
                                var count = 0
                                
                                
                                if indexPath.row > self.TableData.count || self.TableData[indexPath.row].count < 3 {
                                    self.performSegue(withIdentifier: "Safety", sender: self)
                                }
                                
                                
                                let idlabel = self.TableData[indexPath.row][3]
                                self.ref?.child("Votes").child(idlabel).observeSingleEvent(of: .value, with: { (snapshot) in
                                    let usersDict = snapshot.value as? NSDictionary
                                    
                                    if usersDict != nil {
                                        for vall in (usersDict?.allKeys)! {
                                            if vall as! String == name {
                                            
                                            }
                                            count += 1
                                            if count == 1 {
                                                cell.UpvoteLabel.text = "1 UPVOTE"
                                            } else {
                                                cell.UpvoteLabel.text = "\(count) UPVOTES"
                                            }
                                            
                                        }
                                    } else {
                                        cell.UpvoteLabel.text = "0 UPVOTES"
                                    }
                                    
                                    
                                })
                                
                            }
                        }).resume()
                    } else {
                    
                        cell.Pic.image = UIImage()
                        let idlabel = self.TableData[indexPath.row][3]
                        self.ref?.child("Votes").child(idlabel).observeSingleEvent(of: .value, with: { (snapshot) in
                            let usersDict = snapshot.value as? NSDictionary
                            var count = 0
                            if usersDict != nil {
                                for vall in (usersDict?.allKeys)! {
                                    if vall as! String == name {
                                        
                                    }
                                    count += 1
                                    if count == 1 {
                                        cell.UpvoteLabel.text = "1 UPVOTE"
                                    } else {
                                        cell.UpvoteLabel.text = "\(count) UPVOTES"
                                    }
                                    
                                }
                            } else {
                                cell.UpvoteLabel.text = "0 UPVOTES"
                            }
                            
                            
                        })
                    
                    
                    
                    
                    
                    }
                    
                }
                
            })
            
            cell.NameLabel.text = name
            if name == "nmamoon" {
                //print("NABEEEEEL")
                cell.contentView.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
                cell.NameLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.Content.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.UpvoteLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.TimeLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.Pic.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
            }
            cell.Content.text = content
            
            
            
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            let newdate = dateFormatter.date(from: date)!
            let secondsSincePosted = -(newdate.timeIntervalSinceNow)
            //var toPresent: String?
            //let minutes = Int(secondsSincePosted / 60)
            let timeleft = (8*3600) - secondsSincePosted
            if (timeleft < 0) {
                //DateLabel.text = "LOCKED"
                
            }
            let hours = floor(Double(timeleft/3600))
            //let min = floor((timeleft).truncatingRemainder(dividingBy: 3600)/100)
            let min = floor(Double(Int(timeleft) % 3600))/60
            let timeString = String(format: "%02d:%02d", Int(hours), Int(min))
            if (timeleft < 0) {
                cell.TimeLabel.text = "LOCKED"
                
            } else {
                cell.TimeLabel.text = "\(timeString) LEFT"
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            return cell
        } else {
            let urlstring = TableData[indexPath.row][3]
            //print(urlstring)
            let cell = PostTable.dequeueReusableCell(withIdentifier: "piccell") as! ImageTableViewCell
            cell.NameLabel.text = name
            cell.Content.text = content
            if name == "nmamoon" {
                //print("NABEEEEEL")
                cell.contentView.backgroundColor = UIColor(hue: 0.15, saturation: 0.33, brightness: 0.99, alpha: 1.0)
                cell.NameLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.Content.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.UpvoteLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.TimeLabel.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
                cell.ProfilePic.backgroundColor = UIColor(hue: 0.1361, saturation: 0.81, brightness: 0.99, alpha: 1.0)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            let newdate = dateFormatter.date(from: date)!
            let secondsSincePosted = -(newdate.timeIntervalSinceNow)
            //var toPresent: String?
            //let minutes = Int(secondsSincePosted / 60)
            let timeleft = (8*3600) - secondsSincePosted
            if (timeleft < 0) {
                //DateLabel.text = "LOCKED"
                
            }
            let hours = floor(Double(timeleft/3600))
            //let min = floor((timeleft).truncatingRemainder(dividingBy: 3600)/100)
            let min = floor(Double(Int(timeleft) % 3600))/60
            let timeString = String(format: "%02d:%02d", Int(hours), Int(min))
            if (timeleft < 0) {
                cell.TimeLabel.text = "LOCKED"
                
            } else {
                cell.TimeLabel.text = "\(timeString) LEFT"
            }
            let url = URL.init(string: urlstring)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    //print(error!)
                    return
                }
                self.ref?.child("Users").child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                    let usersDict = snapshot.value as? NSDictionary
                    
                    if usersDict != nil {
                        for vall in (usersDict?.allKeys)! {
                            //print("HOKUM")
                            //print(vall)
                            
                        }
                        if let link = usersDict?["Picture"] as? String {
                            let url = URL.init(string: link)
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                
                                if error != nil {
                                    //print(error!)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    cell.ProfilePic.image = UIImage(data: data!)
                                    var count = 0
                                     //print("WHAGH")
                                    //print(self.TableData.count)
                                    //print(indexPath.row)
                                    //print("WHAGH")
                                    //print(self.TableData[indexPath.row].count)
                                    if indexPath.row > self.TableData.count || self.TableData[indexPath.row].count < 3 {
                                        self.performSegue(withIdentifier: "Safety", sender: self)
                                    } else {
                                        
                                        
                                        let idlabel = self.TableData[indexPath.row][4]
                                        self.ref?.child("Votes").child(idlabel).observeSingleEvent(of: .value, with: { (snapshot) in
                                            let usersDict = snapshot.value as? NSDictionary
                                            
                                            if usersDict != nil {
                                                for vall in (usersDict?.allKeys)! {
                                                    if vall as! String == name {
                                                        
                                                    }
                                                    count += 1
                                                    if count == 1 {
                                                        cell.UpvoteLabel.text = "1 UPVOTE"
                                                    } else {
                                                        cell.UpvoteLabel.text = "\(count) UPVOTES"
                                                    }
                                                    
                                                }
                                            } else {
                                                cell.UpvoteLabel.text = "0 UPVOTES"
                                            }
                                            
                                            
                                            
                                        })

                                    }
                                    
                                    
                                }
                            }).resume()
                        } else {
                        
                        
                            cell.ProfilePic.image = UIImage()
                            let idlabel = self.TableData[indexPath.row][4]
                            self.ref?.child("Votes").child(idlabel).observeSingleEvent(of: .value, with: { (snapshot) in
                                let usersDict = snapshot.value as? NSDictionary
                                var count = 0
                                if usersDict != nil {
                                    for vall in (usersDict?.allKeys)! {
                                        if vall as! String == name {
                                            
                                        }
                                        count += 1
                                        if count == 1 {
                                            cell.UpvoteLabel.text = "1 UPVOTE"
                                        } else {
                                            cell.UpvoteLabel.text = "\(count) UPVOTES"
                                        }
                                        
                                    }
                                } else {
                                    cell.UpvoteLabel.text = "0 UPVOTES"
                                }
                                
                                
                            })
                        
                        
                        
                        }
             
                        
                    }

                })
                

                DispatchQueue.main.async {
                    cell.ConPic.image = UIImage(data: data!)
                }
            }).resume()
            return cell
        }
    }
    
    @IBAction func SelectPic(_ sender: UIButton) {
        
        if typing {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated:true, completion:nil)
            usepic = true
        }
        
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
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func DeletePic(_ sender: UIButton) {
        picholder = UIImage()
        TestImage.image = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row > TableData.count || TableData[indexPath.row].count < 3 {
            performSegue(withIdentifier: "Safety", sender: self)
        }
        
        
        let num = TableData[indexPath.row].count
        if num == 4 {
            
            let currentCell = PostTable.cellForRow(at: indexPath) as! BasicPostCell
            let name = TableData[indexPath.row][0]
            let date = TableData[indexPath.row][1]
            let content = TableData[indexPath.row][2]
            let id = TableData[indexPath.row][3]
            nameprep = name
            dateprep = date
            contentprep = content
            idprep = id
            profileprep = currentCell.Pic.image
            self.performSegue(withIdentifier: "FeedToPost", sender: self)
            
            
            
        } else {
            let currentCell = PostTable.cellForRow(at: indexPath) as! ImageTableViewCell
            let name = TableData[indexPath.row][0]
            let date = TableData[indexPath.row][1]
            let content = TableData[indexPath.row][2]
            let id = TableData[indexPath.row][4]
            nameprep = name
            dateprep = date
            contentprep = content
            idprep = id
            imageprep = currentCell.ConPic.image
            profileprep = currentCell.ProfilePic.image
            self.performSegue(withIdentifier: "FeedToImage", sender: self)
        }
        
 
        //if currentCell.isread {
        //   return
        //}
        // currentCell.isread = true
        
        /*
        if Boolthreads[indexPath.section][indexPath.row] == true {
            return
        }
        Boolthreads[indexPath.section][indexPath.row] = true
        //Boolthreads[indexPath.section].removeLast()
        
        Boolthreads[indexPath.section].append(true)
        var holder = threads[threadNames[indexPath.section]]?[indexPath.row]
        holderImage.image = holder
        picholder = holder
        //storeString = currentCell.SelectionCell.text!
        // let hold = "Post To: " + storeString
        // PostButton.setTitle(hold, for: .normal)
        Boolthreads[indexPath.section].removeLast()
        self.performSegue(withIdentifier: "SectionsToPic", sender: self)
 */
    }
    

}
