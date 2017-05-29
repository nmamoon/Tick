//
//  PicViewController.swift
//  Tick
//
//  Created by Nabeel Mamoon on 5/27/17.
//  Copyright © 2017 Nabeel Mamoon. All rights reserved.
//

import UIKit

class PicViewController: UIViewController {

    
    @IBOutlet weak var Image: UIImageView!
    
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Image.layer.masksToBounds = true
        Image.layer.cornerRadius = 15
        Image.image = img
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
