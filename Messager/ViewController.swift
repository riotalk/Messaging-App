//
//  ViewController.swift
//  Messager
//
//  Created by Mario  on 11/18/15.
//  Copyright © 2015 BBG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var welcomeLbl: UILabel!
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!

    @IBOutlet weak var loginBtn: UIButton!
    
    
    @IBOutlet weak var signupBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        welcomeLbl.center = CGPointMake(theWidth/2, 130)
        usernameTxt.frame = CGRectMake(16, 200, theWidth-32, 30)
        passwordTxt.frame = CGRectMake(16, 240, theWidth-32, 30)
        loginBtn.center = CGPointMake(theWidth/2, 330)
        signupBtn.center = CGPointMake(theWidth/2, theHeight-30)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func loginBtn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!){
            (user:PFUser?, logInError:NSError?) -> Void in
            
            if logInError == nil {
                
                
               print("log in")
                
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                
                
                self.performSegueWithIdentifier("goToUserVC", sender: self)

        }else{
            
            print("error log in")
        }
        
            
        }
    }
    
}


