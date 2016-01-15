//
//  conversationVC.swift
//  Messager
//
//  Created by Mario  on 12/23/15.
//  Copyright © 2015 BBG. All rights reserved.
//

import UIKit

var otherName = ""
var otherProfileName = ""

class conversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var resultsScrollView: UIScrollView!
    
    @IBOutlet weak var frameMessageView: UIView!
    
    @IBOutlet weak var lineLbl: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    let mLbl = UILabel(frame: CGRectMake(5,8, 200,20))
    
    var messageX: CGFloat = 37.0
    var messageY: CGFloat = 26.0
    var frameX: CGFloat = 32.0
    var frameY: CGFloat = 21.0
    var imgX: CGFloat = 3
    var imgY: CGFloat = 3
    
    
    
    var messageArray = [String]()
    var senderArray = [String]()
    
    var myImg:UIImage? = UIImage()
    var otherImg: UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        
        resultsScrollView.frame = CGRectMake(0, 64, theWidth, theHeight-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultsScrollView.frame.maxY, theWidth, 50)
        lineLbl.frame = CGRectMake(0, 0, theWidth, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendBtn.center = CGPointMake(frameMessageView.frame.size.width-30, 24)
        
        
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        self.title = otherProfileName
        
        mLbl.text = "Type a Message..."
        mLbl.backgroundColor = UIColor.clearColor()
        mLbl.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mLbl)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "getMessageFunc:", name: "getMessage", object: nil)
       
    }
    
    
    func getMessageFunc() {
        
        refreshResults()
        
    }
    
    func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        if !messageTextView.hasText() {
            
            self.mLbl.hidden = false
            
        } else {
            
            self.mLbl.hidden = true
            
        }
    
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if !messageTextView.hasText() {
           
            self.mLbl.hidden = false
        }
        
        
    }
    
    func keyboardWasShown(notification:NSNotification) {
        
        let dict: NSDictionary = notification.userInfo!
        let s: NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            let bottonOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottonOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
        
        })
        
        
    }
    
    func keyboardWillHide(notification:NSNotification) {
        
        let dict: NSDictionary = notification.userInfo!
        let s: NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            let bottonOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottonOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        var objects = try? query.findObjects()
        
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        for object in objects! {
            
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsImageFiles[0].getDataInBackgroundWithBlock {
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil {
                    self.myImg = UIImage(data: imageData!)
                    
                    var query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherName)
                    var objects2 = try! query2.findObjects()
                    
                    self.resultsImageFiles2.removeAll(keepCapacity: false)
                    
                    for object in objects2 {
                        
                        self.resultsImageFiles2.append(object["photo"] as! PFFile)
                        
                        self.resultsImageFiles2[0].getDataInBackgroundWithBlock {
                            
                            (imageData:NSData?, error:NSError?) -> Void in
                            
                            if error == nil {
                                
                                self.otherImg = UIImage(data: imageData!)
                                
                                self.refreshResults()
                                
                                
                                
                                
                             
                                
                            }
                                
                                
                                
                            }
                    }
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    func refreshResults()  {
        
    
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX  = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3
            
            
        
        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherName)
        let innerQ1 = PFQuery(className: "Messages", predicate: innerP1)
        
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName,userName)
        let innerQ2 = PFQuery(className: "Messages", predicate: innerP2)
        
        let query = PFQuery.orQueryWithSubqueries([innerQ1,innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?,error:NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                    
                }
                
                for var i = 0; i <= self.messageArray.count-1; i++ {
                    
                    if self.senderArray[i] == userName {
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl:UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                        frameLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                        
                        
                        
                        
                        
                    }else{
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width-94, CGFloat.max)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        
                        var frameLbl:UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.size.width+10, messageLbl.frame.size.height+10)
                       
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.otherImg
                        img.frame = CGRectMake(self.imgX ,self.imgY, 34,34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        

                        
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)

                        
                        
                        
                    }
                    
                    var bottonOffset:CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottonOffset, animated: false)
                    
                    }
                }
            
            }
            
        }
    
    @IBAction func sendBtn_click(sender: AnyObject) {
        
        if messageTextView.text == "" {
            
            print("no text")
            
        } else{
            
                var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock {
                (success:Bool , error:NSError?) -> Void in
                
                
                let uQuery:PFQuery = PFUser.query()!
                uQuery.whereKey("username", equalTo: otherName)
                
                let pushQuery:PFQuery = PFInstallation.query()!
                pushQuery.whereKey("user", matchesQuery: uQuery)
                
                let push:PFPush = PFPush()
                push.setQuery(pushQuery)
                push.setMessage("New Message")
                //push.sendPush()
                
                do {
                    try push.sendPush()
                    
                } catch {
                    
                }
                
                print("push sent")
                
                print("meesage sent")
                self.messageTextView.text = ""
                self.mLbl.hidden = false
                self.refreshResults()
                
                
                }
            
            let pushData = [
                
                "alert" : "New message",
                
                "sound" : "messageNotification.wav"
                
            ]
            
            let uQuery:PFQuery = PFUser.query()!
            
            uQuery.whereKey("username", equalTo: otherName)
            
            let pushQuery:PFQuery = PFInstallation.query()!
            
            pushQuery.whereKey("user", matchesQuery: uQuery)
            
            let push:PFPush = PFPush()
            
            push.setQuery(pushQuery)
            
            push.setData(pushData)
            
            push.sendPushInBackground()
        
            }
        
        }
    }
    


