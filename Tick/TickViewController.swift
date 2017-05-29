//
//  TickViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/9/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit
import QuartzCore
import Firebase
import FirebaseAuth
import FirebaseStorage

class TickViewController: UIViewController {

    @IBOutlet weak var WelcomeBar: UILabel!
    
    @IBOutlet weak var SignBar: UIButton!
    
    @IBOutlet weak var LogBar: UIButton!
    
    
    
    
    
    
    @IBOutlet weak var decorator0: UIButton!
    @IBOutlet weak var decorator1: UIButton!
    @IBOutlet weak var decorator2: UIButton!
    @IBOutlet weak var decorator3: UIButton!
    @IBOutlet weak var decorator4: UIButton!
    @IBOutlet weak var decorator5: UIButton!
    @IBOutlet weak var decorator6: UIButton!
    @IBOutlet weak var decorator7: UIButton!
    
     var gradient : CAGradientLayer?;
     var ref:FIRDatabaseReference?
    
    override func viewDidAppear(_ animated: Bool) {
        // Checks if user is already signed in and skips login
        
        if FIRAuth.auth()?.currentUser != nil {
            
            ref?.child("Channel").child((FIRAuth.auth()?.currentUser?.displayName)!).observeSingleEvent(of: .value, with: { (snapshot) in
                let userchan = snapshot.value as? String
                
                if userchan != nil {
                    channel = userchan!
                } else {
                    channel = "Default"
                }
                  self.performSegue(withIdentifier: "AutomaticToMain", sender: self)
                
                
            })
            
            
            
            
            
            
            
            
          
        }
 
 
    }
    
 
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        WelcomeBar.layer.masksToBounds = true
        WelcomeBar.layer.cornerRadius = 20
        SignBar.backgroundColor = WelcomeBar.backgroundColor
        SignBar.layer.cornerRadius = 20
        LogBar.backgroundColor = WelcomeBar.backgroundColor
        LogBar.layer.cornerRadius = 20
        
        decorator0.layer.cornerRadius = 18
        decorator1.layer.cornerRadius = 15
        decorator2.layer.cornerRadius = 10
        decorator3.layer.cornerRadius = 15
        decorator4.layer.cornerRadius = 10
        decorator5.layer.cornerRadius = 8
        decorator6.layer.cornerRadius = 10
        decorator7.layer.cornerRadius = 8
        
        
        super.viewDidLoad()
        
        self.gradient = CAGradientLayer()
        self.gradient?.frame = self.view.bounds
        
        
        var col = UIColor(hue: 0.275, saturation: 0.68, brightness: 0.97, alpha: 1.0)
        
        self.gradient?.colors = [ col.cgColor, col.cgColor]
        self.view.layer.insertSublayer(self.gradient!, at: 0)
        
        animateLayer()
    
        

        // Do any additional setup after loading the view.
    }
    
    func animateLayer(){
        
        var fromColors = self.gradient?.colors
        var toColors: [AnyObject] = [ UIColor.clear.cgColor, UIColor.clear.cgColor]
        self.gradient?.colors = toColors // You missed this line
        var animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        //var animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 5.00
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //animation.delegate = self as UIViewController
        
        self.gradient?.add(animation, forKey:"animateGradient")
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
    @IBAction func SignUpClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToSignUp", sender: self)
    }
    
    @IBAction func LoginClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToSignIn", sender: self)
    }
    
    

}
