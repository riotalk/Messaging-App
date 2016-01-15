//
//  signupVC.swift
//  Messager
//
//  Created by Mario  on 11/19/15.
//  Copyright © 2015 BBG. All rights reserved.
//

import UIKit

class signupVC: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var addPicbtn: UIButton!
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var profileTxt: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        profilePic.center = CGPointMake(theWidth/2, 140)
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        
        
        
        addPicbtn.center = CGPointMake(self.profilePic.frame.maxX+50, 140)
        usernameTxt.frame = CGRectMake(16, 230, theWidth-32, 30)
        passwordTxt.frame = CGRectMake(16, 270, theWidth-32, 30)
        profileTxt.frame =  CGRectMake(16, 310, theWidth-32, 30)
        signupBtn.center = CGPointMake(theWidth/2, 380)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPicbtn(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        profilePic.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        profileTxt.resignFirstResponder()
        
        return true 
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        if (UIScreen.mainScreen().bounds.height == 568) {
           
            if (textField == self.profileTxt) {
            
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                  
                    self.view.center = CGPointMake(theWidth/2, (theHeight/2)-40)
                    
                    }, completion: {
                        (finished:Bool) in
            
                        //
        
                })
                
        
            }
        
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        if (UIScreen.mainScreen().bounds.height == 568) {
            
            if (textField == self.profileTxt) {
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
                    
                    self.view.center = CGPointMake(theWidth/2, (theHeight/2))
                    
                    }, completion: {
                        (finished:Bool) in
                        
                        //
                        
                })
                
                
            }
            
        }
    

        
    }
    
    
    @IBAction func signupBtn(sender: AnyObject) {
        
        var user = PFUser()
        user.username = usernameTxt.text
        user.password = passwordTxt.text
        user.email = usernameTxt.text
        user["profileName"] = profileTxt.text
        
        let imageData = UIImagePNGRepresentation(self.profilePic.image!)
        let imageFile = PFFile(name: "profilePic.png", data: imageData!)
        user["photo"] = imageFile

        user.signUpInBackgroundWithBlock {
            (succeeded:Bool!, signUpError:NSError?) -> Void in
            
            if signUpError == nil {
             
                print("signup")
                
                var installation: PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()

                
                
            self.performSegueWithIdentifier("goToUserVC2", sender: self)
            
        } else {
            
            print("can't signup")
            
            
        
            }
        
        }
    }

}
