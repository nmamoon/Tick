//
//  BasicPostViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/14/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class BasicPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var ContentLabel: UILabel!
    
    @IBOutlet weak var Comments: UITableView!
    
    @IBOutlet weak var NameLabel: UIButton!
    
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var UpvoteCount: UILabel!
    
    @IBOutlet weak var UpvoteButton: UIButton!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    
    @IBOutlet weak var PostButton: UIButton!
    
    var ref:FIRDatabaseReference?
    
    
    @IBOutlet weak var ReportButton: UIButton!
    
    
    @IBOutlet weak var XButton: UIButton!
    
    
    @IBOutlet weak var HideButton: UIButton!
    
    
    var TableData = [[String]]()
    
    let myname = FIRAuth.auth()?.currentUser?.displayName
    
    //
    var namelab: String?
    var conlab: String?
    var idlab: String?
    var datelab: String?
    var newdate: Date?
    var profImage: UIImage?
    var mytimer:Timer?
    var votebool: Bool?
    var locked: Bool?
    var commented: Bool?
    
    var blocked = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        Comments.delegate = self
        Comments.dataSource = self
        Comments.rowHeight = 120
        Comments.estimatedRowHeight = 120
        votebool = false
        commented = false
        DateLabel.layer.masksToBounds = true
        DateLabel.layer.cornerRadius = 15
        ContentLabel.layer.masksToBounds = true
        ContentLabel.layer.cornerRadius = 15
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = 15
        IDLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 15
        UpvoteCount.layer.masksToBounds = true
        UpvoteCount.layer.cornerRadius = 15
        UpvoteButton.layer.cornerRadius = 15
        PostButton.layer.cornerRadius = 15
        ReportButton.layer.cornerRadius = 15
        XButton.layer.cornerRadius = 15
        HideButton.layer.cornerRadius = 15
        NameLabel.setTitle(namelab, for: UIControlState.normal)
        ContentLabel.text = conlab
        IDLabel.text = idlab
        ProfilePic.layer.masksToBounds = true
        ProfilePic.layer.cornerRadius = 15
        ProfilePic.image = profImage
        
        DateLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        // Do any additional setup after loading the view.
        
        
        
        
        self.ref?.child("Users").child(namelab!).child("Blocks").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                blockedUsers = [String]()
                for vall in (usersDict?.allKeys)! {
                    if vall as! String == FIRAuth.auth()?.currentUser?.displayName! {
                        self.blocked = true
                    }
                    
                }
                //self.MyTable.reloadData()
            } else {
                //cell.UpvoteLabel.text = "0 UPVOTES"
            }
            
            
            
        })
        
        
        
        
        
        
        //let newdate = datelab! as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        newdate = dateFormatter.date(from: datelab!)!
        
        
        let secondsSincePosted = -(newdate?.timeIntervalSinceNow)!
        var toPresent: String?
        let minutes = Int(secondsSincePosted / 60)
        if minutes < 1 {
            toPresent = "Posted \(floor(secondsSincePosted)) seconds ago"
        } else if minutes == 1 {
            toPresent = "Posted \(minutes) minute ago"
        } else if minutes < 60 {
            toPresent = "Posted \(minutes) minutes ago "
        } else if minutes < 120 {
            toPresent = "Posted 1 hour ago"
        } else if minutes < 24 * 60 {
            toPresent = "Posted \(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            toPresent = "Posted 1 day ago"
        } else {
            toPresent = "Posted \(minutes / 1440) days ago"
        }
        IDLabel.text = toPresent
        let timeleft = (8*3600) - secondsSincePosted
        if (timeleft < 0) {
            locked = true
        } else {
            locked = false
        }
        if (timeleft < 0) {
            DateLabel.text = "LOCKED"
            return
        }
        let hours = floor(Double(timeleft/3600))
        //let min = floor((timeleft).truncatingRemainder(dividingBy: 3600)/100)
        let min = floor(Double(Int(timeleft) % 3600))/60
        let timeString = String(format: "%02d:%02d", Int(hours), Int(min))
        
        DateLabel.text = "\(timeString) left"
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
        
        
        
            
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            //print("DISPATCH")
            self.Comments.reloadData()
        }
            
        let when2 = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when2) {
            //print("DISPATCH")
            self.Comments.reloadData()
        }
        
     
        
        mytimer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                       selector: #selector(BasicPostViewController.updateTime(_timer:)),
                                       userInfo: nil,
                                       repeats: true)
        
        
        
        self.TableData = [[String]]()
     
        ref?.child("Comments").child(idlab!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                   
                    if vall as! String == self.myname {
                        self.commented = true
                        self.PostButton.setTitle("COMMENTED", for: UIControlState.normal)
                        self.PostButton.backgroundColor = UIColor.green
                    }
                    let vallcom = usersDict?[vall] as! NSDictionary
                    let comm = vallcom["Post"] as! String
                    
                    if vallcom["quips"] != nil {
                        let newdict = vallcom["quips"] as! NSDictionary
                    }
                    
                    self.ref?.child("Users").child(vall as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        let usersDict = snapshot.value as? NSDictionary
                        
                        if usersDict != nil {
                            for vall in (usersDict?.allKeys)! {
                                //print("HOKUMM")
                                //print(vall)
                                
                            }
                            
                            
                            //print("DOWN HERE")
                            //print(vall)
                            
                            self.ref?.child("Comments").child(self.idlab!).child(vall as! String).child("Upvoters").observeSingleEvent(of: .value, with: { (snapshot) in
                                let newDict = snapshot.value as? NSDictionary
                                var count = 0
                                var tester = false
                                //print("GOTT HERE")
                                //var commented = false
                                if newDict != nil {
                                    //print("NOW HERE")
                                    for value in (newDict?.allKeys)! {
                                        if value as! String == self.myname {
                                            tester = true
                                        }
                                        //print("HOKUM")
                                        //print(vall)
                                        count += 1
                                        
                                    }
                                    
                                    let link = usersDict?["Picture"]
                                    //print(link!)
                                    self.TableData.append([vall as! String, comm, link as! String, String(count), String(tester)])
                                    //print("WAITING")
                                    //print(self.TableData.count)
                                    
                                    
                                    
                                    self.TableData.sort {
                                       
                                        let first = Int($0[3])!
                                        //print("WAHHH")
                                       // print(first)
                                        let second = Int($1[3])!
                                        //print(second)
                                        return (first > second)
                                    }
                                    
                                    
                                    
                                    
                                    //self.Comments.reloadData()
                                    //print("NOWWWW")
                                    //print(comm)
                                   
                                } else {
                                   
                                    //print("EVEN FURTHER")
                                    
                                    let link = usersDict?["Picture"]
                                    //print(link!)
                                    self.TableData.append([vall as! String, comm, link as! String, String(0), String(false)])
                                    //print("WAITING")
                                    //print(self.TableData.count)
                                    self.TableData.sort {
                                        
                                        let first = Int($0[3])!
                                        let second = Int($1[3])!
                                        return (first > second)
                                    }
                                    
                                    //
                                    //print("POWWW")
                                    //print(comm)
                                    //return cell
                                }
                                
                                if !self.locked! {
                                    self.Comments.reloadData()
                                }
                                
                            })
                            
                            
                            
                            
                          
                            
                            
                        }
                        
                        
                        
                    })
                   
                    
                    
                }
            }
            
            
            
        })
    
        
        
        
        var count = 0
        self.UpvoteCount.text = "0 UPVOTES"
        ref?.child("Votes").child(idlab!).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersDict = snapshot.value as? NSDictionary
            
            if usersDict != nil {
                for vall in (usersDict?.allKeys)! {
                    //print("HOKUM")
                    //print(vall)
                    
                    
                    if vall as! String == self.myname {
                        self.votebool = true
                        if self.votebool == true {
                            self.UpvoteButton.setTitle("UPVOTED", for: UIControlState.normal)
                            self.UpvoteButton.backgroundColor = UIColor.green
                        }
                        self.UpvoteCount.text = "\(count) UPVOTES"
                    }
                    count += 1
                    self.UpvoteCount.text = "\(count) UPVOTES"
                    
                    
                    
                }
            }
            
            
            
        })
        
        
        
        
        
        let secondsSincePosted = -(newdate?.timeIntervalSinceNow)!
        var toPresent: String?
        let minutes = Int(secondsSincePosted / 60)
        if minutes < 1 {
            toPresent = "Posted \(floor(secondsSincePosted)) seconds ago"
        } else if minutes == 1 {
            toPresent = "Posted \(minutes) minute ago"
        } else if minutes < 60 {
            toPresent = "Posted \(minutes) minutes ago "
        } else if minutes < 120 {
            toPresent = "Posted 1 hour ago"
        } else if minutes < 24 * 60 {
            toPresent = "Posted \(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            toPresent = "Posted 1 day ago"
        } else {
            toPresent = "Posted \(minutes / 1440) days ago"
        }
        IDLabel.text = toPresent
        let timeleft = (8*3600) - secondsSincePosted
        if (timeleft < 0) {
            locked = true
        } else {
            locked = false
        }
        if (timeleft < 0) {
            DateLabel.text = "LOCKED"
            return
        }
        let hours = floor(Double(timeleft/3600))
        //let min = floor((timeleft).truncatingRemainder(dividingBy: 3600)/100)
        let min = floor(Double(Int(timeleft) % 3600))/60
        let timeString = String(format: "%02d:%02d", Int(hours), Int(min))
        
        DateLabel.text = "\(timeString) left"

        
       
        
        
        
        
 
        
        
      
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime(_timer: Timer) {
        
        let secondsSincePosted = -(newdate?.timeIntervalSinceNow)!
        var toPresent: String?
        let minutes = Int(secondsSincePosted / 60)
        if minutes < 1 {
             toPresent = "Posted \(floor(secondsSincePosted)) seconds ago"
        } else if minutes == 1 {
            toPresent = "Posted \(minutes) minute ago"
        } else if minutes < 60 {
            toPresent = "Posted \(minutes) minutes ago "
        } else if minutes < 120 {
            toPresent = "Posted 1 hour ago"
        } else if minutes < 24 * 60 {
            toPresent = "Posted \(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            toPresent = "Posted 1 day ago"
        } else {
            toPresent = "Posted \(minutes / 1440) days ago"
        }
        IDLabel.text = toPresent
        let timeleft = (8*3600) - secondsSincePosted
        
        
        
        if (timeleft < 0) {
            DateLabel.text = "LOCKED"
            //Comments.reloadData()
            return
        }
        let hours = floor(Double(timeleft/3600))
        //let min = floor((timeleft).truncatingRemainder(dividingBy: 3600)/100)
        let min = floor(Double(Int(timeleft) % 3600))/60
        let timeString = String(format: "%02d:%02d", Int(hours), Int(min))
        
        DateLabel.text = "\(timeString) left"
        
    }

    
    @IBAction func UpVote(_ sender: UIButton) {
        let cUser = FIRAuth.auth()?.currentUser
        
        if !votebool! {
            self.ref?.child("Votes").child(idlab!).child((cUser?.displayName)!).setValue(cUser?.displayName)
            UpvoteButton.backgroundColor = UIColor.green
            UpvoteButton.setTitle("UPVOTED", for: UIControlState.normal)
            votebool = true
        } else {
            UpvoteButton.backgroundColor = NameLabel.backgroundColor
            UpvoteButton.setTitle("UPVOTE", for: UIControlState.normal)
            self.ref?.child("Votes").child(idlab!).child((cUser?.displayName)!).removeValue()
            votebool = false
        }
        viewDidAppear(true)

        
    }
    
    
    
    @IBAction func GoToBio(_ sender: UIButton) {
        performSegue(withIdentifier: "PostToBio", sender: self)
    }
    
    
    
    @IBAction func PostTouched(_ sender: UIButton) {
        if blocked {
            let popup = UIAlertController(
                title: "Not possible.",
                message: "This user has blocked you, so you cannot comment.",
                preferredStyle: .alert)
            
            let exit = UIAlertAction(title: "OK!", style: .default) {
                action in self.sOver() }
            
            popup.addAction(exit)
            
            //print("Well we are here!")
            
            self.present(popup, animated:true)
            return
        }
        if !locked! && !commented! {
            performSegue(withIdentifier: "BasicPostToComment", sender: self)
        } else {
            if commented! {
                print("yes1")
                ref?.child("Decider").observeSingleEvent(of: .value, with: { (snapshot) in
                    let info = snapshot.value as? String
                    print("yes2")
                    if info != nil {
                        print(info)
                        //bootest = false
                        if info! == "true" {
                            print("yes4")
                            self.ref?.child("Comments").child(self.idlab!).child(self.myname!).removeValue()
                            self.viewDidAppear(true)
                            
                        }
                    }
                    
                    
                    
                    
                })
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(TableData.count)
        return TableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("ENTERING HERE")
        for s in TableData {
            //print(s[0])
        }
     
        
        if locked! {
            
            
            if indexPath.row == TableData.count - 1 {
                if TableData.count > 1 {
                    self.ref?.child("Reveals").child(TableData[0][0]).child(self.idlab!).setValue("Won")
                    for i in 1..<TableData.count {
                        self.ref?.child("Reveals").child(TableData[i][0]).child(self.idlab!).removeValue()
                    }
                }
                
            }
            
            
            var name = TableData[indexPath.row][0]
            let comment = TableData[indexPath.row][1]
            let num = Int(TableData[indexPath.row][3])!
            let boolen = TableData[indexPath.row][4]
            
            if indexPath.row == 0 {
                
                //print("WINNING")
                
                let cell = Comments.dequeueReusableCell(withIdentifier: "ImageComm") as! WinningCell
               // print("NOW 1")
                if boolen == "true" {
                    cell.VotesLabel.backgroundColor = UIColor.green
                    
                } else {
                    cell.VotesLabel.backgroundColor = self.NameLabel.backgroundColor
                }
                  //print("NOW 2")
                
               
                if let link = TableData[indexPath.row][2] as? String {
                    let url = URL.init(string: link)
                    //print("NOW 5")
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            //print(error!)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            cell.ProfilePic.image = UIImage(data: data!)
                            if num == 1 {
                                cell.VotesLabel.text = "1 VOTE"
                            } else {
                                cell.VotesLabel.text = "\(num) VOTES"
                            }
                            cell.CommentLabel.text = comment
                            cell.NameLabel.text = name
                            //print("ZERO")
                            //print(name)
                            
                            
                            
                        }
                    }).resume()
                }

                
                /*
                ref?.child("Users").child(TableData[0][0]).observeSingleEvent(of: .value, with: { (snapshot) in
                    let usersDict = snapshot.value as? NSDictionary
                    
                      //print("NOW 3")
                    
                    if usersDict != nil {
                          //print("NOW 4")
                       
                        if let link = usersDict?["Picture"] as? String {
                            let url = URL.init(string: link)
                              //print("NOW 5")
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                
                                if error != nil {
                                    print(error!)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    cell.ProfilePic.image = UIImage(data: data!)
                                    if num == 1 {
                                        cell.VotesLabel.text = "1 VOTE"
                                    } else {
                                        cell.VotesLabel.text = "\(num) VOTES"
                                    }
                                    cell.CommentLabel.text = comment
                                    cell.NameLabel.text = name
                                    print("ZERO")
                                    print(name)
                                    
                                    
                                    
                                }
                            }).resume()
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                })
                 */
                
                return cell
            
            } else {
                
                //print("WAITING")
                let cell = Comments.dequeueReusableCell(withIdentifier: "BasicComm") as! WaitingCell
                
                if boolen == "true" {
                    cell.VotesLabel.backgroundColor = UIColor.green
                    
                } else {
                    cell.VotesLabel.backgroundColor = self.NameLabel.backgroundColor
                }
                
                
                
                if num == 1 {
                    cell.VotesLabel.text = "1 VOTE"
                } else {
                    cell.VotesLabel.text = "\(num) VOTES"
                }
                cell.CommentLabel.text = comment
                return cell
                
            }
        } else {
            let name = TableData[indexPath.row][0]
            let comment = TableData[indexPath.row][1]
            let num = Int(TableData[indexPath.row][3])!
            let boolen = TableData[indexPath.row][4]
            //print("BOOLLEENN")
            
            //print(comment)
            let cell = Comments.dequeueReusableCell(withIdentifier: "BasicComm") as! WaitingCell
            
            if boolen == "true" {
                cell.VotesLabel.backgroundColor = UIColor.green
                
            } else {
                cell.VotesLabel.backgroundColor = self.NameLabel.backgroundColor
            }
            
            
            
            if num == 1 {
                cell.VotesLabel.text = "1 VOTE"
            } else {
                cell.VotesLabel.text = "\(num) VOTES"
            }
            cell.CommentLabel.text = comment
            return cell
        }
        
        
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cUser = FIRAuth.auth()?.currentUser
        let tname = TableData[indexPath.row][0]
        let mname = cUser?.displayName
        
        //print("DURRR")
        //print(locked)
        
        if !locked! {
            
            
            
            
            ref?.child("Comments").child(idlab!).child(tname).child("Upvoters").observeSingleEvent(of: .value, with: { (snapshot) in
                let usersDict = snapshot.value as? NSDictionary
                
                if usersDict != nil {
                    var commented = false
                    for vall in (usersDict?.allKeys)! {
                       // print("IN HERE")
                        //print(vall)
                        
                        
                        if vall as! String == self.myname {
                            self.ref?.child("Comments").child(self.idlab!).child(tname).child("Upvoters").child(mname!).removeValue()
                            commented = true
                            self.viewDidAppear(true)
                            self.Comments.reloadData()
                            
                        }
                        
                        
                    }
                    
                    if !commented {
                        
                        self.ref?.child("Comments").child(self.idlab!).child(tname).child("Upvoters").child(mname!).setValue("commented")
                        self.viewDidAppear(true)
                        self.Comments.reloadData()
                       
                        
                        
                    }

                } else {
                    //print("IN THERE")
                    self.ref?.child("Comments").child(self.idlab!).child(tname).child("Upvoters").child(mname!).setValue("commented")
                    self.viewDidAppear(true)
                    self.Comments.reloadData()
                }
                
                
                
            })
            
            
            
            
            
            
            
            
        }
        
        
        
        }
        
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FriendBioViewController {
            
            dest.nametext = namelab
            dest.testimage = profImage
            
        }
        if let dest = segue.destination as? CommentViewController{
            
            dest.imagepost = false
            dest.basicpost = true
            dest.postid = idlab
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    func sOver() {
        //viewDidLoad()
        //gameOver = true
    }
    
    
    @IBAction func ReportPressed(_ sender: UIButton) {
        self.ref?.child("Reports").child(idlab!).setValue("Reported")
        let popup = UIAlertController(
            title: "This Post has been reported.",
            message: "Thank you for your report. We will review the content and the comments as soon as possible. If you have further questions, please contact us at tick.app.contact@gmail.com.",
            preferredStyle: .alert)
        
        let exit = UIAlertAction(title: "Ok", style: .default) {
            action in self.sOver() }
        
        popup.addAction(exit)
        
        //print("Well we are here!")
        
        self.present(popup, animated:true)
        
    }
    
    @IBAction func XPressed(_ sender: UIButton) {
        if namelab == FIRAuth.auth()?.currentUser?.displayName! || FIRAuth.auth()?.currentUser?.displayName! == "nmamoon" {
             self.ref?.child(channel).child("Posts").child(idlab!).removeValue()
            print("done")
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: "ToMain", sender: self)
        } else {
            let popup = UIAlertController(
                title: "This is not your post!",
                message: "You cannot remove a post that isn't yours. If you object to the material, please hide if from your feed, or use the report button.",
                preferredStyle: .alert)
            
            let exit = UIAlertAction(title: "Ok", style: .default) {
                action in self.sOver() }
            
            popup.addAction(exit)
            
            //print("Well we are here!")
            
            self.present(popup, animated:true)

        }
        
    }
    
    
    @IBAction func hidePressed(_ sender: UIButton) {
        
        /*
        let popup = UIAlertController(
            title: "Hide this Post?",
            message: "If you hide this post, it will no longer appear on your feed.",
            preferredStyle: .alert)
        
        let exit = UIAlertAction(title: "Ok", style: .default) {
            action in self.sOver() }
        
        popup.addAction(exit)
        
        //print("Well we are here!")
        
        self.present(popup, animated:true)
         */
        self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.displayName)!).child("Hidings").child(idlab!).setValue("HIDDEN")
        
        
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
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "ToMain", sender: self)

        //performSegue(withIdentifier: "ToMain", sender: self)
        
        }
    
    

}
